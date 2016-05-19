package hw09;

import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;
import java.util.Map;
import java.util.TreeMap;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.concurrent.TimeUnit;

/**
 * Local account cache.
 */
class AccountCache {
	private final Account account;
	private Integer peeked = null; /* Peeked-at value */
	private Integer value = null; /* Updated value */
	public boolean opened = false; /*
									 * Indicator: true if opened; otherwise false
									 */

	public AccountCache(Account account) {
		this.account = account; /* shared mutable state */
	}

	/**
	 * Peek the account.
	 * 
	 * @return the value stored in the account
	 */
	public int peek() {
		if (peeked == null && value == null) {
			peeked = account.peek();
			value = peeked;
		}
		return value;
	}

	/**
	 * Update the account.
	 * 
	 * @param newValue
	 *            the new value you want to update
	 */
	public void update(int newValue) {
		value = newValue;
	}

	/**
	 * Open the account for verification or writing.
	 * 
	 * @throws TransactionAbortException
	 */
	public void open() throws TransactionAbortException {
		synchronized (account) {
			if (forVerification()) {
				account.open(false);
				opened = true;
				account.verify(peeked);
			}
			if (forWriting()) {
				account.open(true);
				opened = true;
			}
		}
	}

	/**
	 * Close the account.
	 */
	public void close() {
		if (opened) {
			account.close();
		}
	}

	/**
	 * Flush the account.
	 */
	public void flush() {
		if (forWriting()) {
			account.update(value);
		}
	}

	/**
	 * Check if verification is needed.
	 * 
	 * @return true if needed, otherwise false
	 */
	private boolean forVerification() {
		return peeked != null;
	}

	/**
	 * Check if writing is needed.
	 * 
	 * @return true if needed, otherwise false
	 */
	private boolean forWriting() {
		return peeked == null || value.intValue() != peeked.intValue();
	}
}

// TO DO: Task is currently an ordinary class.
// You will need to modify it to make it a task,
// so it can be given to an Executor thread pool.
//

/**
 * Concurrent task.
 */
class Task implements Runnable {
	private static final int A = constants.A;
	private static final int Z = constants.Z;
	private static final int numLetters = constants.numLetters;

	private Account[] accounts;
	private String transaction;

	private Map<Integer, AccountCache> accountNumToCache = new TreeMap<>();

	// TO DO: The sequential version of Task peeks at accounts
	// whenever it needs to get a value, and opens, updates, and closes
	// an account whenever it needs to set a value. This won't work in
	// the parallel version. Instead, you'll need to cache values
	// you've read and written, and then, after figuring out everything
	// you want to do, (1) open all accounts you need, for reading,
	// writing, or both, (2) verify all previously peeked-at values,
	// (3) perform all updates, and (4) close all opened accounts.

	public Task(Account[] allAccounts, String trans) {
		accounts = allAccounts;
		transaction = trans;
	}

	/**
	 * Given an account number, fetch (or create) the corresponding local
	 * account cache.
	 * 
	 * @param accountNum
	 *            account number
	 * @return local account cache
	 */
	private AccountCache getAccountCache(int accountNum) {
		AccountCache ac;
		if (accountNumToCache.containsKey(accountNum)) {
			ac = accountNumToCache.get(accountNum);
		} else {
			ac = new AccountCache(accounts[accountNum]);
			accountNumToCache.put(accountNum, ac);
		}
		return ac;
	}

	// TO DO: parseAccount currently returns a reference to an account.
	// You probably want to change it to return a reference to an
	// account *cache* instead.
	//

	/**
	 * Given an account name, fetch the corresponding local account cache.
	 * 
	 * @param name
	 *            account name
	 * @return local account cache
	 */
	private AccountCache parseAccount(String name) {
		int accountNum = (int) (name.charAt(0)) - (int) 'A';
		if (accountNum < A || accountNum > Z)
			throw new InvalidTransactionError();
		AccountCache ac = getAccountCache(accountNum);
		for (int i = 1; i < name.length(); i++) {
			if (name.charAt(i) != '*')
				throw new InvalidTransactionError();
			accountNum = (ac.peek() % numLetters);
			ac = getAccountCache(accountNum);
		}
		return ac;
	}

	/**
	 * Given an account name, fetch the stored value.
	 * 
	 * @param name
	 *            account name
	 * @return account value
	 */
	private int parseAccountOrNum(String name) {
		int rtn;
		if (name.charAt(0) >= '0' && name.charAt(0) <= '9') {
			rtn = new Integer(name).intValue();
		} else {
			rtn = parseAccount(name).peek();
		}
		return rtn;
	}

	/**
	 * Run the task.
	 */
	public void run() {
		// tokenize transaction
		String[] commands = transaction.split(";");
		for (int i = 0; i < commands.length; i++) {
			String[] words = commands[i].trim().split("\\s");
			if (words.length < 3)
				throw new InvalidTransactionError();
			AccountCache lhs = parseAccount(words[0]); // l-value
			if (!words[1].equals("="))
				throw new InvalidTransactionError();
			int rhs = parseAccountOrNum(words[2]);
			for (int j = 3; j < words.length; j += 2) {
				if (words[j].equals("+"))
					rhs += parseAccountOrNum(words[j + 1]); // calculate account
															// value
				else if (words[j].equals("-"))
					rhs -= parseAccountOrNum(words[j + 1]); // calculate account
															// value
				else
					throw new InvalidTransactionError();
			}
			lhs.update(rhs);
		}
		try {
			/**
			 * Open all accounts you need, for reading, writing, or both, in an
			 * alphabetical order. Verify all previously peeked-at values if
			 * necessary.
			 */
			for (int accountNum : accountNumToCache.keySet()) {
				AccountCache ac = accountNumToCache.get(accountNum);
				ac.open();
			}

			/**
			 * Flush all accounts which are opened for writing.
			 */
			for (int accountNum : accountNumToCache.keySet()) {
				AccountCache ac = accountNumToCache.get(accountNum);
				ac.flush();
			}
		} catch (TransactionAbortException e) {
			/**
			 * Close all the opened accounts and retry if a
			 * TransactionAbortException error occurs.
			 */
			for (int accountNum : accountNumToCache.keySet()) {
				AccountCache ac = accountNumToCache.get(accountNum);
				ac.close();
			}
			accountNumToCache.clear();
			run();
			return;
		}

		/**
		 * Close all opened accounts.
		 */
		for (int accountNum : accountNumToCache.keySet()) {
			AccountCache ac = accountNumToCache.get(accountNum);
			ac.close();
		}
		System.out.println("commit: " + transaction);
	}
}

/**
 * A multi-threaded server.
 */
public class MultithreadedServer {

	// requires: accounts != null && accounts[i] != null (i.e., accounts are
	// properly initialized)
	// modifies: accounts
	// effects: accounts change according to transactions in inputFile

	/**
	 * 
	 * @param inputFile
	 *            transaction file
	 * @param accounts
	 *            accounts
	 * @throws IOException
	 */
	public static void runServer(String inputFile, Account accounts[]) throws IOException {

		// read transactions from input file
		String line;
		BufferedReader input = new BufferedReader(new FileReader(inputFile));

		// TO DO: you will need to create an Executor and then modify the
		// following loop to feed tasks to the executor instead of running them
		// directly.

		/**
		 * Create an Executor.
		 */
		ExecutorService e = Executors.newCachedThreadPool();

		while ((line = input.readLine()) != null) {
			Task t = new Task(accounts, line);
			e.execute(t);
		}

		input.close();

		e.shutdown();
		try {
			e.awaitTermination(60, TimeUnit.SECONDS);
		} catch (InterruptedException e1) {
		}
		e.shutdownNow();
	}
}

package hw09.test;

import hw09.*;

import java.io.*;
import java.lang.Thread.*;
import java.util.Arrays;
import java.util.HashSet;
import java.util.concurrent.*;
import java.util.Random;

import junit.framework.TestCase;

import org.junit.Test;

public class MultithreadedServerTests extends TestCase {
	private static final int A = constants.A;
	private static final int Z = constants.Z;
	private static final int numLetters = constants.numLetters;
	private static Account[] accounts;

	protected static void dumpAccounts() {
		// output values:
		for (int i = A; i <= Z; i++) {
			System.out.print("    ");
			if (i < 10)
				System.out.print("0");
			System.out.print(i + " ");
			System.out.print(new Character((char) (i + 'A')) + ": ");
			accounts[i].print();
			System.out.print(" (");
			accounts[i].printMod();
			System.out.print(")\n");
		}
	}

	/**
	 * Test case 1: increment
	 */
	@Test
	public void testIncrement() throws IOException {

		// initialize accounts
		accounts = new Account[numLetters];
		for (int i = A; i <= Z; i++) {
			accounts[i] = new Account(Z - i);
		}

		MultithreadedServer.runServer("hw09/data/increment", accounts);

		dumpAccounts();

		// assert correct account values
		for (int i = A; i <= Z; i++) {
			Character c = new Character((char) (i + 'A'));
			assertEquals("Account " + c + " differs", Z - i + 1, accounts[i].getValue());
		}
	}

	/**
	 * Test case 2: indirect
	 */
	// @Test
	public void testIndirect3() throws IOException {

		// initialize accounts
		accounts = new Account[numLetters];
		for (int i = A; i <= Z; i++) {
			accounts[i] = new Account(Z - i);
		}

		MultithreadedServer.runServer("hw09/data/indirect3", accounts);

		dumpAccounts();

		// assert correct account values
		assertEquals("Account A differs", 25, accounts[0].getValue());
		assertEquals("Account B differs", 26, accounts[1].getValue());
	}

	/**
	 * Test case 3: tinyrotate
	 */
	// @Test
	public void testTinyRotate() throws IOException {

		// initialize accounts
		accounts = new Account[numLetters];
		for (int i = A; i <= Z; i++) {
			accounts[i] = new Account(Z - i);
		}

		MultithreadedServer.runServer("hw09/data/tinyrotate", accounts);

		dumpAccounts();
	}

	/**
	 * Test case 4: tinyatomictransfer
	 */
	// @Test
	public void testTinyAtomicTransfer() throws IOException {

		// initialize accounts
		accounts = new Account[numLetters];
		for (int i = A; i <= Z; i++) {
			accounts[i] = new Account(100);
		}

		MultithreadedServer.runServer("hw09/data/tinyatomictransfer", accounts);

		dumpAccounts();

		// assert correct account values
		for (int i = A; i <= A + 2; i++) {
			Character c = new Character((char) (i + 'A'));
			assertEquals("Account " + c + " differs", 100, accounts[i].getValue());
		}
	}
}
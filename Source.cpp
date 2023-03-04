// algorithm. For demonstration values are
#include <iostream>
#include <string.h>
using namespace std;

// Returns gcd of a and b
int gcd(int a, int h)
{
	int temp;
	while (1) {
		temp = a % h;
		if (temp == 0)
			return h;
		a = h;
		h = temp;
	}
}

// Code to demonstrate RSA algorithm
int main()
{	
	string a("ABCDEFGHIJKLMNOPQRSTUVWXYZ");

	string text;
	cin >> text;


	// Two random prime numbers
	double p = 3;
	double q = 7;

	// First part of public key:
	double n = p * q;

	// Finding other part of public key.
	// e stands for encrypt
	double e = 2;
	double phi = (p - 1) * (q - 1);
	while (e < phi) {
		// e must be co-prime to phi and
		// smaller than phi.
		if (gcd(e, phi) == 1)
			break;
		else
			e++;
	}

	// Private key (d stands for decrypt)
	// choosing d such that it satisfies
	// d*e = 1 + k * totient
	int k = 2; // A constant value
	double d = (1 + (k * phi)) / e;
	int msg;

	cout << "Encripted text ";

	for (int i = 0; i < text.size(); i++) {
	
		char letter = text[i];
		for (int j = 0; j <= a.size(); j++)
			if (a[j] == letter)
			{
				msg = j;
				double c = pow(msg, e);
				// Encryption formula c = (msg ^ e) % n
				c = fmod(c, n);
				cout << a[c];
			}

	}
	cout << endl;
	cout << "Decripted text ";

	for (int i = 0; i < text.size(); i++) {
		char letter = text[i];
		for (int j = 0; j <= a.size(); j++)
			if (a[j] == letter)
			{
				msg = j;
				double c = pow(msg, e);
				// Encryption c = (msg ^ e) % n
				c = fmod(c, n);
				//decription formula 
				double m = pow(c, d);
				m = fmod(m, n);
				cout << a[m];
			}

	}
	

	




	return 0;
}
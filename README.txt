This project is base on the truffle framework.

To run the DApp on localhost you should follow these steps:

1.Download ganache client and enter the command ganache-cli on termial.
2.Use truffle migrate to compile and deploy your contract.
3.Run npm run dev and you can see your website on localhost.

To build a public website:
1. delete the dist folder.
2. npm run build.
3. npm run deploy.

To check HTML and Javascript, you can use localhost.
To test contract function, I prefer to use remix: http://remix.ethereum.org/#optimize=false&version=soljson-v0.5.1+commit.c8a2cb62.js
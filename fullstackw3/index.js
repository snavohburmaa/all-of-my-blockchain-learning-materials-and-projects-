import {createWalletClient, custom, createPublicClient} from "https://esm.sh/viem"

const connectButton = document.getElementById('connectButton'); 
const fundButton = document.getElementById('fundButton');
const ethAmountInput = document.getElementById('ethAmount');

let walletClient;
let publicClient;

async function connect() {
    if(typeof window.ethereum !== 'undefined') {
        walletClient = createWalletClient({
            transport: custom(window.ethereum)
        })  
        await walletClient.requestAddresses()   
        console.log(walletClient);
        connectButton.innerHTML = 'Connected';
    } else {
        console.log('MetaMask is not installed!');
    }
}

async function fund() {
    const ethAmount = ethAmountInput.value;
    console.log(`funding with ${ethAmount} ETH`);

    if (typeof window.ethereum !== 'undefined') {
        walletClient = createWalletClient({
            transport: custom(window.ethereum)
        })
        await walletClient.requestAddresses()
        publicClient = createPublicClient({
            transport: custom(window.ethereum)
        })
        await publicClient.simulateContract({
            //address
        })
    } else {
        connectButton.innerHTML = 'Please install MetaMask!';
    }
}

connectButton.onclick = connect
fundButton.onclick = fund
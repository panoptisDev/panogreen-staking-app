import { useState } from "react";
import { ethers } from "ethers";
import ConnectedAccount from "./ConnectedAccount";
import ConnectedNetwork from "./ConnectedNetwork";
//import Button from "../Button/Button";
import "./Navigation.css";

const Navigation = () => {
  const [provider, setProvider] = useState(null);

  const handleWallet = async () => {
    if (window.ethereum) {
      try {
        // Request account access
        await window.ethereum.request({ method: 'eth_requestAccounts' });
        // We don't know window.ethereum version, so we use ethers.js to convert it into a compatible provider
        const provider = new ethers.providers.Web3Provider(window.ethereum);
        setProvider(provider); // Save the provider in the state
      } catch (error) {
        console.error("User denied account access");
      }
    } else {
      console.log("Non-Ethereum browser detected. You should consider trying MetaMask!");
    }
  };

  return (
    <header className="navbar">
      <div className="navbar-btns">
      </div>
      <div className="navbar-acc">
        <ConnectedAccount provider={provider} />
        <ConnectedNetwork provider={provider} />
        <img
          //src="src/assets/banner44.png"
          src="https://iili.io/JNmV6ep.png"
          alt="DigiStake Logo"
          className="logo"
        />
      </div>
    </header>
  );
};

export default Navigation;

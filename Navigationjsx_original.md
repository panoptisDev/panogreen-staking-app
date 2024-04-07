import { useState } from "react";
import ConnectedAccount from "./ConnectedAccount";
import ConnectedNetwork from "./ConnectedNetwork";
import ClaimReward from "../ClaimReward/ClaimReward";
import "./Navigation.css";

const Navigation = () => {
  const [logoSrc, setLogoSrc] = useState("src/assets/banner41.png");

  const handleMouseEnter = () => {
    setLogoSrc("src/assets/banner42.png");
  };

  const handleMouseLeave = () => {
    setLogoSrc("src/assets/banner41.png");
  };

  return (
    <header className="navbar">
      <div className="navbar-btns">
        <ClaimReward />
      </div>
      <div className="navbar-acc">
        <ConnectedAccount />
        <ConnectedNetwork />
        <img
          src={logoSrc}
          alt="DigiStake Logo"
          className="logo"
          onMouseEnter={handleMouseEnter}
          onMouseLeave={handleMouseLeave}
        />
      </div>
    </header>
  );
};

export default Navigation;
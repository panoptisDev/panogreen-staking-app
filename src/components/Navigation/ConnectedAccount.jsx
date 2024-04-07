import { useContext } from "react"
import Web3Context from "../../context/Web3Context"
const ConnectedAccount = ()=>{
    const {selectedAccount}=useContext(Web3Context);
    return (
        <div>
          <p className="connected-ac">
            {selectedAccount ? selectedAccount : "Account"}
          </p>
        </div>
      );

}
export default ConnectedAccount
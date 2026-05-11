import { ethers } from "ethers";
export async function monitorFeeAccumulation(splitterAddress: string, tokens: string[], provider: ethers.JsonRpcProvider) {
  const ERC20_ABI = ["function balanceOf(address) view returns (uint256)", "function symbol() view returns (string)"];
  const ethBal = await provider.getBalance(splitterAddress);
  console.log(`ETH balance: ${ethers.formatEther(ethBal)}`);
  for (const token of tokens) {
    const erc20 = new ethers.Contract(token, ERC20_ABI, provider);
    const [bal, sym] = await Promise.all([erc20.balanceOf(splitterAddress), erc20.symbol()]);
    if (bal > 0) console.log(`${sym}: ${ethers.formatUnits(bal, 6)}`);
  }
}

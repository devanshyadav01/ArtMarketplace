import { useState, useEffect } from "react";
import { ethers } from "ethers";
import artNFTAbi from "../artifacts/contracts/GameToken.sol/ArtNFT.json";

export default function GameToken() {
  const [ethWallet, setEthWallet] = useState(undefined);
  const [account, setAccount] = useState(undefined);
  const [artNFT, setArtNFT] = useState(undefined);
  const [artworks, setArtworks] = useState([]);
  const [title, setTitle] = useState("");
  const [artist, setArtist] = useState("");
  const [price, setPrice] = useState(0);
  const [tokenId, setTokenId] = useState(0);
  const [listPrice, setListPrice] = useState(0);

  const contractAddress = "0xYourDeployedContractAddress";
  const artNFTABI = artNFTAbi.abi;

  const getWallet = async () => {
    if (window.ethereum) {
      setEthWallet(window.ethereum);
    }

    if (ethWallet) {
      const account = await ethWallet.request({ method: "eth_accounts" });
      handleAccount(account);
    }
  };

  const handleAccount = (account) => {
    if (account.length > 0) {
      setAccount(account[0]);
    } else {
      console.log("No account found");
    }
  };

  const connectAccount = async () => {
    if (!ethWallet) {
      alert("MetaMask wallet is required to connect");
      return;
    }

    const accounts = await ethWallet.request({ method: "eth_requestAccounts" });
    handleAccount(accounts);

    getArtNFTContract();
  };

  const getArtNFTContract = () => {
    const provider = new ethers.providers.Web3Provider(ethWallet);
    const signer = provider.getSigner();
    const artNFTContract = new ethers.Contract(contractAddress, artNFTABI, signer);

    if (!artNFTContract || typeof artNFTContract.totalSupply!== 'function') {
      console.error("Failed to create artNFT contract instance.");
      return;
    }

    setArtNFT(artNFTContract);
  };

  const fetchArtworks = async () => {
    if (!artNFT || typeof artNFT.totalSupply!== 'function') {
      console.error("artNFT is not defined or initialized correctly, or totalSupply is not a function.");
      return;
    }

    try {
      const totalSupply = await artNFT.totalSupply();
      let arts = [];

      for (let i = 1; i <= totalSupply; i++) {
        const artData = await artNFT.getArtwork(i);
        arts.push(artData);
      }

      console.log("Fetched artworks:", arts);
      setArtworks(arts);
    } catch (error) {
      console.error("Error fetching artworks:", error);
    }
  };

  const mintArtwork = async () => {
    if (artNFT) {
      const tx = await artNFT.mintArtwork(title, artist, ethers.utils.parseEther(price.toString()));
      await tx.wait();
      fetchArtworks();
    }
  };

  const buyArtwork = async (id, artPrice) => {
    if (artNFT) {
      const tx = await artNFT.buyArtwork(id, { value: ethers.utils.parseEther(artPrice) });
      await tx.wait();
      fetchArtworks();
    }
  };

  const listArtwork = async () => {
    if (artNFT && listPrice > 0) {
      const tx = await artNFT.listArtwork(tokenId, ethers.utils.parseEther(listPrice.toString()));
      await tx.wait();
      fetchArtworks();
    }
  };

  const initUser = () => {
    if (!ethWallet) {
      return <p>Please install MetaMask to use this application.</p>;
    }

    if (!account) {
      return (
        <button onClick={connectAccount}>
          Please connect your MetaMask wallet
        </button>
      );
    }

    if (artworks.length === 0) {
      fetchArtworks();
    }

    return (
      <div>
        <p>Your Account: {account}</p>
        <div>
          <h2>Mint Artwork</h2>
          <input
            type="text"
            value={title}
            onChange={(e) => setTitle(e.target.value)}
            placeholder="Title"
          />
          <input
            type="text"
            value={artist}
            onChange={(e) => setArtist(e.target.value)}
            placeholder="Artist"
          />
          <input
            type="number"
            value={price}
            onChange={(e) => setPrice(Number(e.target.value))}
            placeholder="Price in ETH"
/>
          <button onClick={mintArtwork}>Mint Artwork</button>
        </div>
        <div>
          <h2>Artworks</h2>
          <ul>
            {artworks.map((art, index) => (
              <li key={index}>
                <p>
                  Title: {art.title}
                  <br />
                  Artist: {art.artist}
                  <br />
                  Price: {ethers.utils.formatEther(art.price)} ETH
                </p>
                <button onClick={() => buyArtwork(art.tokenId, art.price)}>Buy</button>
              </li>
            ))}
          </ul>
        </div>
        <div>
          <h2>List Artwork</h2>
          <input
            type="number"
            value={tokenId}
            onChange={(e) => setTokenId(Number(e.target.value))}
            placeholder="Token ID"
          />
          <input
            type="number"
            value={listPrice}
            onChange={(e) => setListPrice(Number(e.target.value))}
            placeholder="List Price in ETH"
          />
          <button onClick={listArtwork}>List Artwork</button>
        </div>
      </div>
    );
  };

  useEffect(() => {
    getWallet();
  }, []);

  return initUser();
}

export default ArtMarketplace;
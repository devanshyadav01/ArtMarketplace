// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

contract ArtNFT {
    // ERC721 Token implementation
    string public name;
    string public symbol;
    mapping(uint256 => address) private _owners;
    mapping(address => uint256) private _balances;
    mapping(uint256 => address) private _tokenApprovals;
    mapping(address => mapping(address => bool)) private _operatorApprovals;

    // Ownable implementation
    address private _owner;

    // Counter implementation
    uint256 private _tokenIdCounter;

    struct Artwork {
        string title;
        string artist;
        uint256 price;
        bool forSale;
    }

    mapping(uint256 => Artwork) public artworks;

    modifier onlyOwner() {
        require(msg.sender == _owner, "You are not the owner");
        _;
    }

    constructor() {
        name = "ArtNFT";
        symbol = "ART";
        _owner = msg.sender;
    }

    // ERC721 functions
    function balanceOf(address owner) public view returns (uint256) {
        require(owner != address(0), "Invalid address");
        return _balances[owner];
    }

    function ownerOf(uint256 tokenId) public view returns (address) {
        address owner = _owners[tokenId];
        require(owner != address(0), "Token does not exist");
        return owner;
    }

    function _transfer(address from, address to, uint256 tokenId) internal {
        require(ownerOf(tokenId) == from, "You are not the owner");
        require(to != address(0), "Invalid address");

        // Clear approvals
        _approve(address(0), tokenId);

        _balances[from] -= 1;
        _balances[to] += 1;
        _owners[tokenId] = to;

        emit Transfer(from, to, tokenId);
    }

    function _approve(address to, uint256 tokenId) internal {
        _tokenApprovals[tokenId] = to;
        emit Approval(ownerOf(tokenId), to, tokenId);
    }

    function approve(address to, uint256 tokenId) public {
        address owner = ownerOf(tokenId);
        require(to != owner, "Cannot approve to owner");

        require(
            msg.sender == owner || isApprovedForAll(owner, msg.sender),
            "Caller is not owner nor approved for all"
        );

        _approve(to, tokenId);
    }

    function getApproved(uint256 tokenId) public view returns (address) {
        require(_exists(tokenId), "Token does not exist");
        return _tokenApprovals[tokenId];
    }

    function setApprovalForAll(address operator, bool approved) public {
        require(operator != msg.sender, "Cannot approve yourself");

        _operatorApprovals[msg.sender][operator] = approved;
        emit ApprovalForAll(msg.sender, operator, approved);
    }

    function isApprovedForAll(address owner, address operator) public view returns (bool) {
        return _operatorApprovals[owner][operator];
    }

    function transferFrom(address from, address to, uint256 tokenId) public {
        require(_isApprovedOrOwner(msg.sender, tokenId), "Caller is not owner nor approved");

        _transfer(from, to, tokenId);
    }

    function _exists(uint256 tokenId) internal view returns (bool) {
        return _owners[tokenId] != address(0);
    }

    function _isApprovedOrOwner(address spender, uint256 tokenId) internal view returns (bool) {
        require(_exists(tokenId), "Token does not exist");
        address owner = ownerOf(tokenId);
        return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
    }

    function mintArtwork(string memory _title, string memory _artist, uint256 _price) public onlyOwner {
        _tokenIdCounter++;
        uint256 newItemId = _tokenIdCounter;
        _mint(msg.sender, newItemId);

        artworks[newItemId] = Artwork({
            title: _title,
            artist: _artist,
            price: _price,
            forSale: true
        });
    }

    function _mint(address to, uint256 tokenId) internal {
        require(to != address(0), "Invalid address");
        require(!_exists(tokenId), "Token already exists");

        _balances[to] += 1;
        _owners[tokenId] = to;

        emit Transfer(address(0), to, tokenId);
    }

    function buyArtwork(uint256 _tokenId) public payable {
        require(_exists(_tokenId), "Artwork does not exist");
        require(artworks[_tokenId].forSale, "Artwork is not for sale");
        require(msg.value >= artworks[_tokenId].price, "Insufficient funds");

        address previousOwner = ownerOf(_tokenId);
        _transfer(previousOwner, msg.sender, _tokenId);
        payable(previousOwner).transfer(msg.value);

        artworks[_tokenId].forSale = false;
    }

    function listArtwork(uint256 _tokenId, uint256 _price) public {
        require(ownerOf(_tokenId) == msg.sender, "You are not the owner");
        artworks[_tokenId].price = _price;
        artworks[_tokenId].forSale = true;
    }

    function getArtwork(uint256 _tokenId) public view returns (string memory, string memory, uint256, bool) {
        require(_exists(_tokenId), "Artwork does not exist");
        Artwork memory art = artworks[_tokenId];
        return (art.title, art.artist, art.price, art.forSale);
    }

    // Ownership transfer
    function transferOwnership(address newOwner) public onlyOwner {
        require(newOwner != address(0), "Invalid address");
        _owner = newOwner;
    }

    event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
    event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
    event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
}

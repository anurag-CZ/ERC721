//SPDX-License-Identifier: MIT
pragma solidity 0.8.7;

interface IERC721 {
    //returns balance of the owner
    function balanceOf(address _owner) external view returns(uint);

    // returns owner of token
    function owner(uint _tokenId) external view returns(address);

    //Safely transfers tokenId token from from to to, checking first that contract recipients are aware of the ERC721 protocol to prevent tokens from being forever locked.
    function safeTransferFrom(address _from, address _to, uint _tokenId) external payable;

    //Safely transfers tokenId token from from to to,addidtional data is passed to _to
    function safeTransferFrom(address _from, address _to, uint _tokenId, bytes memory data) external payable;

    // transfer token from _from to _to
    function transferFrom(address _from, address _to, uint _tokenId) external payable;

    //approve to transfer token from _from to _to. approve is cleared once transfer is over
    function approve(address _approved, uint _tokenId) external payable;

    //Approve or remove operator as an operator for the caller. Operators can call transferFrom or safeTransferFrom for any token owned by the caller.
    function setApprovalForAll(address _operator, bool _approved) external;

    //Returns the account approved for tokenId token.
    function getApproved(uint _tokenId) external view returns(address);

    //Returns if the operator is allowed to manage all of the assets of owner.
    function isApprovedForAll(address _owner, address _operator) external view returns(bool);
 
    //emitted when token is transferred from _from to _to
    event Transfer(address indexed _from, address indexed _to, uint indexed _tokenId);

    //emitted when owner enables manage to approve token.
    event Approval(address indexed _owner, address indexed _approved, uint indexed _tokenId);

    // emitted when owner enables or disables (approved) operator to manage all of its assets.
    event ApprovalForAll(address indexed _owner, address indexed _operator, bool _approved);
}

interface IERC721Metadata {
    function name() external view returns(string memory _name);

    function symbol() external view returns(string memory _symbol);

    function tokenUri(uint _tokenId) external view returns(string memory _tokenurl); 
}

interface IERC721Enumerable {
    function totalSupply() external view returns(uint);

    function tokenByIndex(uint _index) external view returns(uint);

    function tokenOfOwnerByIndex() external view returns(uint);
}
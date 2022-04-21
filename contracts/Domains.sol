// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.10;

import "hardhat/console.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import { StringUtils } from "./libraries/StringUtils.sol";
import {Base64} from "./libraries/Base64.sol";


contract Domains is ERC721URIStorage {

  using Counters for Counters.Counter;
  Counters.Counter private _tokenIds;
  address payable public owner;


  string public tld;
  mapping(string => address) public domains;
  mapping(string => string) public records;
  mapping (uint => string) public names;

  error Unauthorized();
  error AlreadyRegistered();
  error InvalidName(string name);

  string svgPartOne = '<svg xmlns="http://www.w3.org/2000/svg" width="270" height="270" fill="none"><rect width="270" height="270" fill="#0E0E10"/><defs><filter id="A" color-interpolation-filters="sRGB" filterUnits="userSpaceOnUse" height="270" width="270"><feDropShadow dx="0" dy="1" stdDeviation="2" flood-opacity=".225" width="200%" height="200%"/></filter></defs><path d="M21 54.7472V34.4154H26.954V35.798C27.4965 35.3778 28.0522 35.0322 28.6211 34.761C29.19 34.4899 29.7722 34.3544 30.3676 34.3544C31.5584 34.3544 32.7029 34.5713 33.8011 35.005C34.8993 35.4388 35.8783 36.0758 36.7384 36.9162C37.6116 36.0758 38.5908 35.4388 39.6757 35.005C40.7739 34.5713 41.9183 34.3544 43.1091 34.3544C44.8424 34.3544 46.4169 34.7882 47.8326 35.6556C49.2484 36.5096 50.373 37.6617 51.2066 39.1121C52.0533 40.5624 52.4768 42.1686 52.4768 43.9307V54.7472H46.5228V43.9307C46.5228 43.2801 46.3706 42.6972 46.0663 42.1822C45.762 41.6535 45.3518 41.2334 44.8358 40.9216C44.3198 40.6098 43.7442 40.454 43.1091 40.454C42.4873 40.454 41.9184 40.6098 41.4023 40.9216C40.8863 41.2334 40.4762 41.6535 40.1718 42.1822C39.8675 42.6972 39.7154 43.2801 39.7154 43.9307V54.7472H33.7614V43.9307C33.7614 43.2801 33.6092 42.6972 33.3049 42.1822C33.0006 41.6535 32.5904 41.2334 32.0744 40.9216C31.5584 40.6098 30.9895 40.454 30.3676 40.454C29.7457 40.454 29.1702 40.6098 28.641 40.9216C28.1249 41.2334 27.7148 41.6535 27.4105 42.1822C27.1061 42.6972 26.954 43.2801 26.954 43.9307V54.7472H21ZM70.122 34.4154H76.076V54.7472H70.1021L69.8243 52.9174C69.3347 53.6222 68.7129 54.1915 67.9587 54.6252C67.2177 55.059 66.3511 55.2758 65.3588 55.2758C63.8769 55.2758 62.4877 54.9912 61.191 54.4219C59.9076 53.8526 58.7763 53.0665 57.7972 52.0634C56.8181 51.0468 56.0507 49.8811 55.495 48.5663C54.9525 47.238 54.6813 45.8148 54.6813 44.2967C54.6813 42.8463 54.9393 41.4909 55.4553 40.2303C55.9713 38.9697 56.6924 37.865 57.6186 36.9162C58.558 35.9538 59.6363 35.2015 60.8536 34.6594C62.0841 34.1172 63.4006 33.8461 64.8031 33.8461C65.941 33.8461 66.973 34.0901 67.8991 34.5781C68.8386 35.0525 69.6721 35.6488 70.3998 36.3673L70.122 34.4154ZM65.5374 49.4203C66.3974 49.4203 67.1582 49.1898 67.8198 48.729C68.4813 48.2546 68.9775 47.6311 69.3083 46.8585C69.6523 46.0859 69.7647 45.2319 69.6456 44.2967C69.5266 43.4563 69.2289 42.6905 68.7525 41.9992C68.2762 41.3079 67.6875 40.7589 66.9862 40.3523C66.2982 39.9457 65.5639 39.7423 64.7832 39.7423C63.9365 39.7423 63.1823 39.9728 62.5207 40.4336C61.8724 40.8945 61.3828 41.5112 61.0521 42.2838C60.7213 43.0564 60.6088 43.9172 60.7147 44.866C60.847 45.6928 61.1447 46.4518 61.6078 47.1431C62.0841 47.8344 62.6663 48.3902 63.3543 48.8103C64.0423 49.217 64.77 49.4203 65.5374 49.4203ZM93.4129 40.6776C93.0557 40.393 92.6519 40.1693 92.2023 40.0067C91.752 39.8305 91.2558 39.7423 90.7138 39.7423C89.8535 39.7423 89.1322 39.9592 88.5505 40.393C87.9811 40.8267 87.5513 41.4095 87.2605 42.1415C86.969 42.8734 86.8238 43.6867 86.8238 44.5813V54.7472H80.8298V34.4154H86.7841V36.2859C87.4056 35.5675 88.1269 34.9915 88.9474 34.5577C89.7673 34.1104 90.7138 33.8868 91.7855 33.8868C92.2482 33.8868 92.6916 33.9003 93.1152 33.9274C93.5518 33.941 93.9686 34.0088 94.3656 34.1308L93.4129 40.6776ZM103.257 55.1132C102.251 55.0183 101.286 54.7947 100.36 54.4422C99.4333 54.0898 98.6065 53.6086 97.8784 52.9987C97.1509 52.3887 96.5754 51.6432 96.1524 50.7622L101.154 48.5663C101.286 48.7155 101.471 48.9052 101.709 49.1356C101.948 49.3525 102.245 49.5491 102.603 49.7253C102.973 49.9014 103.416 49.9896 103.932 49.9896C104.276 49.9896 104.607 49.9557 104.925 49.8879C105.255 49.8066 105.52 49.6711 105.718 49.4813C105.93 49.2915 106.036 49.0272 106.036 48.6883C106.036 48.3088 105.897 48.0242 105.619 47.8344C105.354 47.6311 105.03 47.4888 104.647 47.4074C104.263 47.3126 103.906 47.238 103.575 47.1838C102.397 46.994 101.266 46.6145 100.181 46.0452C99.1095 45.4624 98.2294 44.7101 97.5416 43.7884C96.8532 42.8531 96.5096 41.762 96.5096 40.5149C96.5096 39.1188 96.8532 37.9125 97.5416 36.8959C98.2425 35.8793 99.1622 35.0999 100.3 34.5577C101.438 34.002 102.662 33.7241 103.972 33.7241C105.52 33.7241 106.949 34.0494 108.259 34.7C109.582 35.3507 110.666 36.2859 111.514 37.5058L106.83 40.3523C106.671 40.149 106.473 39.9457 106.234 39.7423C106.009 39.5255 105.744 39.3425 105.44 39.1934C105.149 39.0307 104.832 38.9291 104.488 38.8884C104.025 38.8477 103.608 38.8681 103.238 38.9494C102.88 39.0172 102.596 39.1662 102.384 39.3967C102.172 39.6135 102.067 39.9321 102.067 40.3523C102.067 40.7454 102.251 41.03 102.622 41.2062C102.993 41.3824 103.409 41.5112 103.873 41.5925C104.335 41.6739 104.712 41.762 105.004 41.8568C106.141 42.2364 107.213 42.7311 108.219 43.3411C109.224 43.951 110.031 44.6898 110.64 45.5572C111.262 46.4247 111.553 47.4413 111.514 48.607C111.514 49.9624 111.117 51.1553 110.323 52.1854C109.529 53.2155 108.503 53.9949 107.247 54.5236C105.989 55.0522 104.66 55.2487 103.257 55.1132Z" fill="#EE4933"/><path fill-rule="evenodd" clip-rule="evenodd" d="M52.8965 44.5004C59.8005 44.5004 65.396 38.9041 65.396 32C65.396 38.9041 70.9924 44.5004 77.8965 44.5004C70.9924 44.5004 65.396 50.0968 65.396 57C65.396 50.0968 59.8005 44.5004 52.8965 44.5004Z" fill="white"/><text x="32.5" y="231" font-size="27" fill="#fff" filter="url(#A)" font-family="Chakra Petch,sans-serif" font-weight="bold">';
  string svgPartTwo = '</text></svg>';

  // Add this anywhere in your contract body
  function getAllNames() public view returns (string[] memory) {
    console.log("Getting all names from contract");
    string[] memory allNames = new string[](_tokenIds.current());
    for (uint i = 0; i < _tokenIds.current(); i++) {
      allNames[i] = names[i];
      console.log("Name for token %d is %s", i, allNames[i]);
  }

    return allNames;
  }

  constructor(string memory _tld) payable ERC721("Mars", "Nars") {
    owner = payable(msg.sender);
    tld = _tld;
    console.log("%s name service deployed", _tld);
  }

  function register(string calldata name) public payable {
    if (domains[name] != address(0)) revert AlreadyRegistered();
    if (!valid(name)) revert InvalidName(name);
    require(domains[name] == address(0));

    uint256 _price = price(name);
    require(msg.value >= _price, "Not enough Matic paid");
		
		// Combine the name passed into the function  with the TLD
    string memory _name = string(abi.encodePacked(name, ".", tld));
		// Create the SVG (image) for the NFT with the name
    string memory finalSvg = string(abi.encodePacked(svgPartOne, _name, svgPartTwo));
    uint256 newRecordId = _tokenIds.current();
  	uint256 length = StringUtils.strlen(name);
		string memory strLen = Strings.toString(length);

    console.log("Registering %s.%s on the contract with tokenID %d", name, tld, newRecordId);

		// Create the JSON metadata of our NFT. We do this by combining strings and encoding as base64
    string memory json = Base64.encode(
      bytes(
        string(
          abi.encodePacked(
            '{"name": "',
            _name,
            '", "description": "Building Martian web by Julio Caesar", "image": "data:image/svg+xml;base64,',
            Base64.encode(bytes(finalSvg)),
            '","length":"',
            strLen,
            '"}'
          )
        )
      )
    );

    string memory finalTokenUri = string( abi.encodePacked("data:application/json;base64,", json));

		console.log("\n--------------------------------------------------------");
	  console.log("Final tokenURI", finalTokenUri);
	  console.log("--------------------------------------------------------\n");

    _safeMint(msg.sender, newRecordId);
    _setTokenURI(newRecordId, finalTokenUri);
    domains[name] = msg.sender;
    names[newRecordId] = name;
    _tokenIds.increment();
  }
  

  function price(string calldata name) public pure returns(uint) {
    uint len = StringUtils.strlen(name);
    require(len > 0);
    if (len == 3) {
      return 5 * 10**17; // 5 MATIC = 5 000 000 000 000 000 000 (18 decimals). We're going with 0.5 Matic cause the faucets don't give a lot
    } else if (len == 4) {
      return 3 * 10**17; // To charge smaller amounts, reduce the decimals. This is 0.3
    } else {
      return 1 * 10**17;
    }
  }


  function getAddress(string calldata name) public view returns (address) {
      // Check that the owner is the transaction sender
      return domains[name];
  }

  function setRecord(string calldata name, string calldata record) public {
      if (msg.sender != domains[name]) revert Unauthorized();
      records[name] = record;
  }

  function getRecord(string calldata name) public view returns(string memory) {
      return records[name];
  }

  function valid(string calldata name) public pure returns(bool) {
    return StringUtils.strlen(name) >= 3 && StringUtils.strlen(name) <= 10;
  }

  modifier onlyOwner() {
  require(isOwner());
  _;
  }

  function isOwner() public view returns (bool) {
    return msg.sender == owner;
  }

  function withdraw() public onlyOwner {
	uint amount = address(this).balance;
	
	  (bool success, ) = msg.sender.call{value: amount}("");
	  require(success, "Failed to withdraw Matic");
  }
}
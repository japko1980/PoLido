// SPDX-FileCopyrightText: 2021 Shardlabs
// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.7;

import "../interfaces/IStakeManager.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract StakeManagerMock is IStakeManager {
    struct State {
        address token;
        uint256 id;
        mapping(address => uint256) validators;
        mapping(uint256 => address) Owners;
    }

    State private state;

    event StakeFor(
        address _user,
        uint256 amount,
        uint256 heimdallFee,
        bool acceptDelegation,
        bytes signerPubkey
    );
    event Unstake(address user, uint256 validatorId);
    event TopUpForFee(address user, uint256 heimdallFee);
    event WithdrawRewards(address user, uint256 validatorId);

    constructor(address _token) {
        state.token = _token;
        state.id = 0;
    }

    function stakeFor(
        address _user,
        uint256 _amount,
        uint256 _heimdallFee,
        bool _acceptDelegation,
        bytes memory _signerPubkey
    ) external override {
        require(msg.sender == _user, "User not valid");
        uint256 id = state.id + 1;
        state.validators[_user] = id;
        state.Owners[id] = _user;
        emit StakeFor(
            _user,
            _amount,
            _heimdallFee,
            _acceptDelegation,
            _signerPubkey
        );
    }

    function unstake(uint256 _validatorId) external override {
        delete state.validators[msg.sender];
        emit Unstake(msg.sender, _validatorId);
    }

    function topUpForFee(address _user, uint256 _heimdallFee)
        external
        override
    {
        emit TopUpForFee(_user, _heimdallFee);
    }

    function getValidatorId(address _user)
        external
        view
        override
        returns (uint256)
    {
        return state.validators[_user];
    }

    function getValidatorContract(uint256 _validatorId)
        external
        view
        override
        returns (address)
    {
        return state.Owners[_validatorId];
    }

    function withdrawRewards(uint256 _validatorId) external override returns (uint256){
        emit WithdrawRewards(msg.sender, _validatorId);
        IERC20(state.token).transfer(msg.sender, 1000);
        return 1000;
    }

    function validatorStake(uint256) external pure override returns (uint256) {
        return 1000;
    }
}

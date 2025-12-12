const { expect } = require("chai");
const { ethers } = require("hardhat");

let token;
let owner;
let manager;
let minter;
let user;

const TOKEN_ADDRESS_PROXY = "0xe7f1725E7734CE288F8367e1Bb143E90bb3F0512";

beforeEach(async function () {
        [owner, manager, minter, user] = await ethers.getSigners();
        token = await ethers.getContractAt(
            "HeavenTokenUpgradeable",
            TOKEN_ADDRESS_PROXY,
            owner
        );
    });

// 基础信息验证
describe("BASE-基础信息验证", function() {

    it("合约名称、符号、小数位应正确", async function () {
        expect(await token.name()).to.equal("Heaven Token");
        expect(await token.symbol()).to.equal("HVN");
        expect(await token.decimals()).to.equal(18);
    })

    it("部署时应向部署者铸造 100 万枚代币", async function () {
        const balance = await token.balanceOf(owner.address);
        expect(balance).to.equal(ethers.parseEther("1000000"));
    });

    it("部署者应同时拥有 ADMIN / MANAGER / MINTER 角色", async function () {
        const DEFAULT_ADMIN_ROLE = await token.DEFAULT_ADMIN_ROLE();
        const MANAGER_ROLE = await token.MANAGER_ROLE();
        const MINTER_ROLE = await token.MINTER_ROLE();

        expect(await token.hasRole(DEFAULT_ADMIN_ROLE, owner.address)).to.be.true;
        expect(await token.hasRole(MANAGER_ROLE, owner.address)).to.be.true;
        expect(await token.hasRole(MINTER_ROLE, owner.address)).to.be.true;
    });

    it("管理员可以授予 MANAGER 和 MINTER 角色", async function () {
        await token.grantRole(await token.MANAGER_ROLE(), manager.address);
        await token.grantRole(await token.MINTER_ROLE(), minter.address);

        expect(await token.hasRole(await token.MANAGER_ROLE(), manager.address)).to.be.true;
        expect(await token.hasRole(await token.MINTER_ROLE(), minter.address)).to.be.true;
    });
});

// 角色更换与权限控制
describe("ROLE-角色更换与权限控制测试", function() {

    it("管理员可以撤销 MANAGER 角色", async function () {
            await token.grantRole(
                await token.MANAGER_ROLE(),
                manager.address
            );

            await token.revokeRole(
                await token.MANAGER_ROLE(),
                manager.address
            );

            expect(
                await token.hasRole(await token.MANAGER_ROLE(), manager.address)
            ).to.be.false;
        });
});

// 铸币权限测试
describe("MINT-铸币权限测试", function() {
    it("普通用户不能铸币", async function () {
            await expect(
                token.connect(user).mint(user.address, ethers.parseEther("1"))
            ).to.be.revertedWith(
                `AccessControl: account ${user.address.toLowerCase()} is missing role ${await token.MINTER_ROLE()}`
            );
        });

    it("拥有 MINTER 角色的账户可以铸币", async function () {
            await token.grantRole(await token.MINTER_ROLE(), minter.address);

            await token
                .connect(minter)
                .mint(user.address, ethers.parseEther("100"));

            expect(await token.balanceOf(user.address))
                .to.equal(ethers.parseEther("100"));
        });
});
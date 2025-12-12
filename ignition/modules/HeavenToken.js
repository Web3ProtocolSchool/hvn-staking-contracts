const { buildModule } = require("@nomicfoundation/hardhat-ignition/modules");

module.exports = buildModule("HeavenTokenModule", (m) => {
  // 部署 HeavenToken 合约
  const heavenToken = m.contract("HeavenToken");

  // 返回实例，供其他 module 依赖
  return { heavenToken };
});
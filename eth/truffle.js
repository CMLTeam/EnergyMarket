module.exports = {
  networks: {
    development: {
      host: "localhost",
      port: 8545,
      network_id: "*" // Match any network id
    },
    azure: {
      host: "eth0r4ncc.westcentralus.cloudapp.azure.com",
      port: 8545,
      network_id: 247
    }
  }
};

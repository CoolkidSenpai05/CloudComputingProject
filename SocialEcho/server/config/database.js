const mongoose = require("mongoose");
mongoose.set("strictQuery", false);
class Database {
  constructor(uri, options) {
    this.uri = uri;
    // Azure Cosmos DB requires retryWrites to be false
    this.options = {
      useNewUrlParser: true,
      useUnifiedTopology: true,
      retryWrites: false,
      ...options,
    };
  }

  async connect() {
    try {
      await mongoose.connect(this.uri, this.options);
      const dbName = mongoose.connection.db?.databaseName || "database";
      console.log(`Connected to database: ${dbName}`);
      console.log(`Database type: ${this.isAzureCosmosDB() ? "Azure Cosmos DB" : "MongoDB"}`);
    } catch (error) {
      throw error;
    }
  }

  async disconnect() {
    try {
      await mongoose.disconnect();
      console.log("Disconnected from database");
    } catch (error) {
      throw error;
    }
  }

  isAzureCosmosDB() {
    // Check if connection string contains cosmos.azure.com or cosmosdb.azure.com
    return this.uri && (
      this.uri.includes("cosmos.azure.com") || 
      this.uri.includes("cosmosdb.azure.com") ||
      this.uri.includes("documents.azure.com")
    );
  }
}

module.exports = Database;

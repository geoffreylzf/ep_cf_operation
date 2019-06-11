class DbSql {
  static final createBranchTable = """
      CREATE TABLE `branch` (
      `id` INTEGER PRIMARY KEY, 
      `branch_code` TEXT, 
      `branch_name` TEXT,
      `company_id` INTEGER);
  """;

  static final createCfMortalityTable = """
      CREATE TABLE `cf_mortality` (
      `id` INTEGER PRIMARY KEY, 
      `sid` INTEGER,
      `company_id` INTEGER,
      `location_id` INTEGER,
      `house_no` INTEGER,
      `record_date` TEXT, 
      `m_qty` INTEGER,
      `r_qty` INTEGER,
      `uuid` TEXT,
      `is_delete` INTEGER DEFAULT 0,
      `is_upload` INTEGER DEFAULT 0,
      `timestamp` TIMESTAMP);
  """;

  static final createTempCfWeightDetailTable = """
      CREATE TABLE `temp_cf_weight_detail` (
      `id` INTEGER PRIMARY KEY, 
      `section` INTEGER,
      `weight` INTEGER,
      `qty` INTEGER,
      `gender` TEXT);
  """;

  static final createCfWeightTable = """
      CREATE TABLE `cf_weight` (
      `id` INTEGER PRIMARY KEY, 
      `sid` INTEGER,
      `company_id` INTEGER,
      `location_id` INTEGER,
      `house_no` INTEGER,
      `day` INTEGER,
      `record_date` TEXT,
      `record_time` TEXT, 
      `uuid` TEXT,
      `is_delete` INTEGER DEFAULT 0,
      `is_upload` INTEGER DEFAULT 0,
      `timestamp` TIMESTAMP);
  """;

  static final createCfWeightDetailTable = """
      CREATE TABLE `cf_weight_detail` (
      `id` INTEGER PRIMARY KEY,
      `cf_weight_id` INTEGER,  
      `section` INTEGER,
      `weight` INTEGER,
      `qty` INTEGER,
      `gender` TEXT);
  """;
}
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
      `remark` TEXT,
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

  static final createFeedTable = """
      CREATE TABLE `feed` (
      `id` INTEGER PRIMARY KEY, 
      `sku_code` TEXT, 
      `sku_name` TEXT);
  """;

  static final createTempCfFeedInDetailTable = """
      CREATE TABLE `temp_cf_feed_in_detail` (
      `id` INTEGER PRIMARY KEY,
      `doc_detail_id` INTEGER,
      `house_no` INTEGER,
      `item_packing_id` INTEGER,
      `compartment_no` TEXT,
      `qty` REAL,
      `weight` REAL);
  """;

  static final createCfFeedInTable = """
      CREATE TABLE `cf_feed_in` (
      `id` INTEGER PRIMARY KEY, 
      `sid` INTEGER,
      `company_id` INTEGER,
      `location_id` INTEGER,
      `record_date` TEXT, 
      `doc_id` INTEGER,
      `doc_no` TEXT,
      `truck_no` TEXT,
      `variance` REAL,
      `uuid` TEXT,
      `is_delete` INTEGER DEFAULT 0,
      `is_upload` INTEGER DEFAULT 0,
      `timestamp` TIMESTAMP);
  """;

  static final createCfFeedInDetailTable = """
      CREATE TABLE `cf_feed_in_detail` (
      `id` INTEGER PRIMARY KEY,
      `cf_feed_in_id` INTEGER,
      `doc_detail_id` INTEGER,
      `house_no` INTEGER,
      `item_packing_id` INTEGER,
      `compartment_no` TEXT,
      `qty` REAL,
      `weight` REAL);
  """;

  static final createWeighingScheduleTable = """
      CREATE TABLE `weighing_schedule` (
      `id` INTEGER PRIMARY KEY,
      `location_id` INTEGER,
      `house_no` INTEGER,
      `day` INTEGER,
      `weighing_date` TEXT);
  """;

  static final createCfFeedDischargeTable = """
      CREATE TABLE `cf_feed_discharge` (
      `id` INTEGER PRIMARY KEY, 
      `sid` INTEGER,
      `company_id` INTEGER,
      `location_id` INTEGER,
      `record_date` TEXT, 
      `discharge_code` TEXT,
      `truck_no` TEXT,
      `uuid` TEXT,
      `is_delete` INTEGER DEFAULT 0,
      `is_upload` INTEGER DEFAULT 0,
      `timestamp` TIMESTAMP);
  """;

  static final createCfFeedDischargeDetailTable = """
      CREATE TABLE `cf_feed_discharge_detail` (
      `id` INTEGER PRIMARY KEY,
      `cf_feed_discharge_id` INTEGER,
      `house_no` INTEGER,
      `item_packing_id` INTEGER,
      `weight` REAL);
  """;

  static final createTempCfFeedDischargeDetailTable = """
      CREATE TABLE `temp_cf_feed_discharge_detail` (
      `id` INTEGER PRIMARY KEY,
      `house_no` INTEGER,
      `item_packing_id` INTEGER,
      `weight` REAL);
  """;

  static final createCfFeedReceiveTable = """
      CREATE TABLE `cf_feed_receive` (
      `id` INTEGER PRIMARY KEY, 
      `sid` INTEGER,
      `company_id` INTEGER,
      `location_id` INTEGER,
      `record_date` TEXT, 
      `discharge_code` TEXT,
      `truck_no` TEXT,
      `variance` REAL,
      `uuid` TEXT,
      `is_delete` INTEGER DEFAULT 0,
      `is_upload` INTEGER DEFAULT 0,
      `timestamp` TIMESTAMP);
  """;

  static final createCfFeedReceiveDetailTable = """
      CREATE TABLE `cf_feed_receive_detail` (
      `id` INTEGER PRIMARY KEY,
      `cf_feed_receive_id` INTEGER,
      `house_no` INTEGER,
      `item_packing_id` INTEGER,
      `weight` REAL);
  """;

  static final createTempCfFeedReceiveDetailTable = """
      CREATE TABLE `temp_cf_feed_receive_detail` (
      `id` INTEGER PRIMARY KEY,
      `house_no` INTEGER,
      `item_packing_id` INTEGER,
      `weight` REAL);
  """;

  static final createCfFeedConsumptionTable = """
      CREATE TABLE `cf_feed_consumption` (
      `id` INTEGER PRIMARY KEY, 
      `sid` INTEGER,
      `company_id` INTEGER,
      `location_id` INTEGER,
      `house_no` INTEGER,
      `record_date` TEXT,
      `item_type_code` TEXT,
      `weight` REAL,
      `uuid` TEXT,
      `is_delete` INTEGER DEFAULT 0,
      `is_upload` INTEGER DEFAULT 0,
      `timestamp` TIMESTAMP);
  """;
}

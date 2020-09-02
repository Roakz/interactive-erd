def key_mapping_list
return array = [
    { :entity => "customers",
      :keys => [
          {:column_name => "customerNumber", :type => "primary"},
          {:column_name => "salesRepEmployeeNumber", :type => "foreign", :ref_table => "employees", :ref_col => "employeeNumber" }
        ]
    },
    { :entity => "employees",
      :keys => [
          {:column_name => "employeeNumber", :type => "primary"},
          {:column_name => "reportsTo", :type => "foreign", :ref_table => "employees", :ref_col => "employeeNumber"},
          {:column_name => "officeCode", :type => "foreign", :ref_table => "offices", :ref_col => "officeCode"}
        ]
    },
    { :entity => "offices",
      :keys => [
          {:column_name => "officeCode", :type => "primary"}
        ]
    },
    { :entity => "orderdetails",
      :keys => [
          {:column_name => "orderNumber", :type => "primary"},
          {:column_name => "productCode", :type => "primary"},
          {:column_name => "orderNumber", :type => "foreign", :ref_table => "orders", :ref_col => "orderNumber"},
          {:column_name => "productCode", :type => "foreign", :ref_table => "products", :ref_col => "productCode"},
        ]
    },
    { :entity => "orders",
      :keys => [
          {:column_name => "orderNumber", :type => "primary"},
          {:column_name => "customerNumber", :type => "foreign", :ref_table => "customers", :ref_col => "customerNumber"}
        ]
    },
    { :entity => "payments",
      :keys => [
          {:column_name => "customerNumber", :type => "primary"},
          {:column_name => "checkNumber", :type => "primary"},
          {:column_name => "customerNumber", :type => "foreign", :ref_table => "customers", :ref_col => "customerNumber"}
        ]
    },
    { :entity => "productlines",
      :keys => [
          {:column_name => "productLine", :type => "primary"}
        ]
    },
    { :entity => "products",
      :keys => [
          {:column_name => "productCode", :type => "primary"},
          {:column_name => "productLine", :type => "foreign", :ref_table => "productlines", :ref_col => "productLine"}
        ]
    }
]
end
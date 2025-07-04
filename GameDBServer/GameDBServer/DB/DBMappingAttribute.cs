﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace GameDBServer.DB
{

    [AttributeUsage(AttributeTargets.Property | AttributeTargets.Field, AllowMultiple = false, Inherited = true)]
    public class DBMappingAttribute : Attribute
    {
        public string ColumnName { get; set; }
    }
}

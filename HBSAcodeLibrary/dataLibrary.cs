using System;
using System.Collections.Generic;
using System.Linq;
using System.Data.SqlClient;
using System.Data;
using System.IO;

namespace HBSAcodeLibrary
{
    public class SQLcommands
    {
        internal static string ConnString()
        {
            //gets the string from local file, and decodes it if needed.
            string connStr = File.ReadAllText(System.Web.HttpContext.Current.Server.MapPath("~/App_Data/HBSA.dat"));
            if (connStr.StartsWith("[connStr]"))
                return connStr.Substring(9).Trim();
            else  //connStr.StartsWith("UnClear: ")
                return HBSAencoder.Decode(connStr);
        }
        public static Object ExecScalar(String proc, List<SqlParameter> parameters = null)
        {
            object result = DBNull.Value;

            using (SqlConnection cn = new SqlConnection(ConnString()))
            {
                cn.Open();

                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.Connection = cn;
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = proc;
                    if (parameters != null)
                    {
                        foreach (SqlParameter param in parameters)
                        {
                            cmd.Parameters.Add(param);
                        }
                    }

                    result = cmd.ExecuteScalar();

                }

                cn.Close();
            }

            return result;
        }
        public static void ExecNonQuery(String proc, List<SqlParameter> parameters = null, SqlInfoMessageEventHandler infoMsgEventHandler = null)
        {
            using (SqlConnection cn = new SqlConnection(ConnString()))
            {
                cn.Open();
                if (infoMsgEventHandler != null)
                    cn.InfoMessage += infoMsgEventHandler;

                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.Connection = cn;
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = proc;
                    if (parameters != null)
                    {
                        foreach (SqlParameter param in parameters)
                        {
                            cmd.Parameters.Add(param);
                        }
                    }

                    cmd.ExecuteNonQuery();

                    cn.Close();
                }
            }
        }
        public static DataTable ExecDataTable(String proc, List<SqlParameter> parameters = null)
        {
            return ExecDataSet(proc, parameters).Tables[0];
        }
        public static DataSet ExecDataSet(String proc, List<SqlParameter> parameters = null)
        {
            using (SqlConnection cn = new SqlConnection(ConnString()))
            {
                cn.Open();
                DataSet ds = new DataSet();

                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.Connection = cn;
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = proc;
                    if (parameters != null)
                    {
                        foreach (SqlParameter param in parameters)
                        {
                            cmd.Parameters.Add(param);
                        }
                    }

                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                    {
                        da.Fill(ds);
                    }

                }

                cn.Close();
                return ds;
            }
        }

        #region IDisposable implementation with finalizer
        private bool isDisposed = false;
        public void Dispose()
        {
            Dispose(true);
            GC.SuppressFinalize(this);
        }
        protected virtual void Dispose(bool disposing)
        {
            if (!isDisposed)
            {
                if (disposing)
                {
                    //TODO: dispose managed objects
                }
                //TODO: free unmanaged resources (unmanaged objects)
                //TODO: set large fields to null.
            }
            isDisposed = true;
        }
        #endregion
    }
    public class SharedRoutines
    {
        public static DataTable TeamList(int SectionID)
        {
            return SQLcommands.ExecDataTable("TeamList",
                                              new List<SqlParameter> { new SqlParameter("SectionID", SectionID) });
        }
        public static DataTable FullteamList()
        {
            return SQLcommands.ExecDataTable("FullTeamList");
        }
        public static DataTable PlayersForTeam(int TeamID)
        {
            return SQLcommands.ExecDataTable("GetPlayers",
                                              new List<SqlParameter> { new SqlParameter("TeamID", TeamID) });
        }
        public static void InsertNewAdministrator(string username)
        {
            SQLcommands.ExecNonQuery("InsertNewAdministrator",
                                      new List<SqlParameter> { new SqlParameter("username", username) });
        }
        public static DataTable HandicapChangesReport(int NoOfDays = 7)
        {
            return SQLcommands.ExecDataTable("HandicapChangesReport",
                                              new List<SqlParameter> { new SqlParameter("NoOfDays", NoOfDays) });
        }
        public static DataTable NewRegistrationsReport(int sectionID = 0, int clubID = 0,
                                                       bool searchByName = false, string player = "",
                                                       int NoOfDays = 7)
        {
            List<SqlParameter> parameters = new List<SqlParameter> {
                new SqlParameter("NoOfDays", NoOfDays),
                new SqlParameter("ClubID",clubID),
            };
            if (sectionID >= 100)
            {
                parameters.Add(new SqlParameter("LeagueID", sectionID - 100));
                parameters.Add(new SqlParameter("SectionID", 0));
            }
            else
            {
                parameters.Add(new SqlParameter("LeagueID", 0));
                parameters.Add(new SqlParameter("SectionID", sectionID));
            }
            if (searchByName)
            {
                parameters.Add(new SqlParameter("Player", player));
            }

            return SQLcommands.ExecDataTable("NewRegistrations", parameters);
        }
        public static void KeepOver70FlagOff()
        {
            SQLcommands.ExecNonQuery("KeepOver70FlagOff");
        }
        public static DataTable CheckAdminLogin(string userName, string Password)
        {
            return SQLcommands.ExecDataTable("adminCheckLogin",
                                              new List<SqlParameter> { new SqlParameter("userName", userName),
                                                                       new SqlParameter("Password", HBSAcodeLibrary.Utilities.RFC2898_Hash(Password))});
        }
        public static DataTable FindEmailAddresses(string EmailAddress)
        {
            return SQLcommands.ExecDataTable("FindEmailAddress",
                                              new List<SqlParameter> { new SqlParameter("EmailAddress", EmailAddress) });
        }
        public static void ReplaceEmailAddress(string CurrentEmailAdress, string newEmailAddress)
        {
            SQLcommands.ExecNonQuery("ReplaceEmailAddress",
                                      new List<SqlParameter> { new SqlParameter("OldEmailAddress", CurrentEmailAdress),
                                                               new SqlParameter("NewEmailAddress", newEmailAddress) });
        }
        public static DataTable EmailAddressDetail(string TableName, string ColumnName, string eMailAddress)
        {
            return SQLcommands.ExecDataTable("EmailAddressDetail",
                                              new List<SqlParameter> { new SqlParameter("TableName", TableName),
                                                                       new SqlParameter("ColumnName", ColumnName),
                                                                       new SqlParameter("eMailAddress", eMailAddress) });
        }
        public static DataTable FindPhoneNos(string PhoneNo)
        {
            return SQLcommands.ExecDataTable("FindPhoneNumber",
                                              new List<SqlParameter> { new SqlParameter("PhoneAddress", PhoneNo) });
        }
        public static void ReplacePhoneNo(string CurrentPhoneNo, string newPhoneNo)
        {
            SQLcommands.ExecNonQuery("ReplacePhoneNumber",
                                      new List<SqlParameter> { new SqlParameter("OldPhoneNumber", CurrentPhoneNo),
                                                               new SqlParameter("NewPhoneNumber", newPhoneNo) });
        }
        public static DataTable PhoneNoDetail(string TableName, string ColumnName, string PhoneNo)
        {
            return SQLcommands.ExecDataTable("PhoneNoDetail",
                                              new List<SqlParameter> { new SqlParameter("TableName", TableName),
                                                                       new SqlParameter("ColumnName", ColumnName),
                                                                       new SqlParameter("PhoneNo", PhoneNo) });
        }
        public static DataTable PrivacyReport(int ClubID, int Type, string Privacy)
        {
            List<SqlParameter> parameters = new List<SqlParameter>
            {
                new SqlParameter("ClubID", ClubID),
                new SqlParameter("Type", Type),
            };
            if (Privacy == "Any")
                parameters.Add(new SqlParameter("Privacy", null));
            else
                parameters.Add(new SqlParameter("Privacy", Privacy));

            return SQLcommands.ExecDataTable("PrivacyReport", parameters);
        }
        static string FormatUKPhoneNumber(string phoneNo)
        {
            List<string> specials = new List<string>
            {
                "019756","0##### #####",
                "019755","0##### #####",
                "019467","0##### #####",
                "017687","0##### #####",
                "017684","0##### #####",
                "017683","0##### #####",
                "016977","0##### #####",
                "016977","0##### ####", // len 10
                "016974","0##### #####",
                "016973","0##### #####",
                "015396","0##### #####",
                "015395","0##### #####",
                "015394","0##### #####",
                "015242","0##### #####",
                "013873","0##### #####",
                "013398","0##### #####",
                "013397","0##### #####",
                "01484" ,"0#### ######",  //Huddersfield !
            };

            int ix = 0;
            bool isAspecial = false;
            while (ix < specials.Count)
            {
                if (phoneNo.StartsWith(specials[ix]))
                {
                    isAspecial = true;
                    if (phoneNo.Length == specials[ix + 1].Replace(" ", "").Length)
                        return Convert.ToInt64(phoneNo).ToString(specials[ix + 1]);
                }

                ix += 2;
            }

            if (isAspecial)
                return "ERROR: Invalid length for the area code.";
            else
            {
                List<string> prefixes = new List<string>
                    {//  list of prefixes in the order with which to examine, each with the format string
                    "011","0### ### ####",
                    //"01#1","0### ### ####",  treated special
                    "01","0#### ######",
                    "01","0#### #####", //Len 10
                    "02","0## #### ####",
                    "03","0### ### ####",
                    "05","0#### ######",
                    "07","0#### ######",
                    "0800","0### ######", //len 10
                    "08","0### ### ####",
                    "09","0### ### ####"
                };
                ix = 0;
                while (ix < prefixes.Count)
                {
                    if (phoneNo.StartsWith(prefixes[ix]) && phoneNo.Length == prefixes[ix + 1].Replace(" ", "").Length)
                    {
                        if (phoneNo.StartsWith("01") && phoneNo.Substring(3, 1) == "1")
                            return Convert.ToInt64(phoneNo).ToString("0### ### ####");
                        else
                            return Convert.ToInt64(phoneNo).ToString(prefixes[ix + 1]);
                    }

                    ix += 2;
                }

                return "ERROR: Invalid phone no: ";
            }
        }
        public static string CheckValidPhoneNoForHuddersfield(string phoneNo)
        {
            phoneNo = phoneNo.Replace(" ", "");

            if (phoneNo.Length < 6) //no matter what format length must be greater than 10
                return "ERROR: Invalid length";

            string numbers;

            if (phoneNo.Substring(0, 1) == "+")
                if (phoneNo.Substring(1, 2) != "44")
                    return "ERROR: International number";
                else
                    numbers = phoneNo.Substring(3);
            else
            if (phoneNo.Substring(0, 2) == "00")
                if (phoneNo.Substring(2, 2) != "44")
                    return "ERROR: International number";
                else
                    numbers = phoneNo.Substring(4);
            else
            if (phoneNo.Substring(0, 1) == "0")
                numbers = phoneNo.Substring(1);
            else
                if (phoneNo.Length == 6)
                numbers = "1484" + phoneNo;
            else
                return "ERROR: Not valid UK number";

            if (!new System.Text.RegularExpressions.Regex("[0-9]").IsMatch(numbers))
                return "ERROR: Not numeric";

            if ((numbers.Length > 10 | numbers.Length < 9) && numbers.Length != 6)
                return "ERROR: Invalid length";

            return FormatUKPhoneNumber('0' + numbers);
        }
        public static DataTable BreaksReport(int leagueID)
        {
            return SQLcommands.ExecDataTable("BreaksReport",
                                              new List<SqlParameter> { new SqlParameter("LeagueID", leagueID) });
        }
        public static DataTable ListAdjustedPoints()
        {
            return SQLcommands.ExecDataTable("ListAdjustedPoints");
        }
        public static void MergeAGM_Vote(int ClubID, int ResolutionID, bool For, bool Against, bool Withheld)
        {
            SQLcommands.ExecNonQuery("MergeAGM_Vote",
                                     new List<SqlParameter> { new SqlParameter("ClubID", ClubID)
                                                             ,new SqlParameter("ResolutionID",ResolutionID)
                                                             ,new SqlParameter("For",For)
                                                             ,new SqlParameter("Against",Against)
                                                             ,new SqlParameter("Withheld",Withheld) });
        }
        public static DataTable ReportAGM_Vote(int ClubID = 0, int Type = 0)
        {
            return SQLcommands.ExecDataTable("ReportAGM_Vote",
                                     new List<SqlParameter> { new SqlParameter("ClubID", ClubID),
                                                              new SqlParameter("Type", Type) });
        }
        public static DataTable FullReportAGM_Vote(int ClubID = 0, int Type = 0)
        {
            return SQLcommands.ExecDataTable("FullReportAGM_Vote",
                                     new List<SqlParameter> { new SqlParameter("ClubID", ClubID),
                                                              new SqlParameter("Type", Type) });
        }
        public static DataTable ContactsReport()
        {
            return SQLcommands.ExecDataTable("ContactsReport");
        }
        public static DataTable DataForDownload(string SPname)
        {
            return SQLcommands.ExecDataTable(SPname);
        }
    }
    public class Administrator : IDisposable 
    {
        public string Username;
        public string Password;
        public string Forename;
        public string Surname;
        public string Email;
        public string Function;
        public Administrator()
        {
                Username = " ";
                Password = "";
                Forename = "";
                Surname  = "";
                Email    = "";
                Function = "";
        }
        public Administrator(string username)
        {
            DataRow administrator =
                        SQLcommands.ExecDataTable("GetAdministrator",
                            new List<SqlParameter> { new SqlParameter("Username", username) }).Rows[0];
            if (administrator != null)
            {
                Username = (string)administrator["Username"];
                Password = (string)administrator["Password"];
                Forename = (string)administrator["Forename"];
                Surname = (string)administrator["Surname"];
                Email = (string)administrator["Email"];
                Function = (string)administrator["Function"];
            }
        }
        public void Insert()
        {
            SQLcommands.ExecNonQuery("InsertNewAdministrator",
                new List<SqlParameter> { new SqlParameter("Username",Username),
                                         new SqlParameter("Password",Password),
                                         new SqlParameter("Forename",Forename),
                                         new SqlParameter("Surname",Surname),
                                         new SqlParameter("Email",Email),
                                         new SqlParameter("Function",Function) });
        }
        public void Amend()
        {
            SQLcommands.ExecNonQuery("AmendAdministrator",
                new List<SqlParameter> { new SqlParameter("Username",Username),
                                         new SqlParameter("Password",Password),
                                         new SqlParameter("Forename",Forename),
                                         new SqlParameter("Surname",Surname),
                                         new SqlParameter("Email",Email),
                                         new SqlParameter("Function",Function) });
        }
        public void Delete()
        {
            SQLcommands.ExecNonQuery("DeleteAdministrator",
                new List<SqlParameter> { new SqlParameter("Username", Username) });

        }
        public static DataTable GetAdministrators()
        {
            return SQLcommands.ExecDataTable("GetAdministrators");
        }
        #region IDisposable implementation 
        private bool isDisposed = false;
        public void Dispose()
        {
            Dispose(true);
            GC.SuppressFinalize(this);
        }
        protected virtual void Dispose(bool disposing)
        {
            if (!isDisposed)
            {
                if (disposing)
                {
                    //TODO: dispose managed objects
                }
                //TODO: free unmanaged resources (unmanaged objects)
                //TODO: set large fields to null.
            }
            isDisposed = true;
        }
        #endregion
    }
    public class ActivityLog : IDisposable
    {
        public static void LogActivity(string activity, int keyID, String byWhom)
        {
            List<SqlParameter> parameters = new List<SqlParameter>()
            {
                new SqlParameter("Activity", activity),
                new SqlParameter("keyID", keyID),
                new SqlParameter("byWhom", byWhom)
            };

            SQLcommands.ExecNonQuery("LogActivity", parameters);
        }

        public static DataTable ActivityReport(DateTime StartDateTime,
                                               DateTime EndDateTime,
                                               String Activity,
                                               String Action,
                                               String What)
        {
            List<SqlParameter> parameters = new List<SqlParameter>()
            {
                new SqlParameter("From", StartDateTime),
                new SqlParameter("To", EndDateTime),
                new SqlParameter("Activity", Activity),
                new SqlParameter("Action", Action),
                new SqlParameter("What", What),
            };

            return SQLcommands.ExecDataTable("ActivityLogReport", parameters);
        }

        public static DataTable ActivityLogActions()
        {
            return SQLcommands.ExecDataTable("ActivityLogActions");
        }

        #region IDisposable implementation 
        private bool isDisposed = false;
        public void Dispose()
        {
            Dispose(true);
            GC.SuppressFinalize(this);
        }
        protected virtual void Dispose(bool disposing)
        {
            if (!isDisposed)
            {
                if (disposing)
                {
                    //TODO: dispose managed objects
                }
                //TODO: free unmanaged resources (unmanaged objects)
                //TODO: set large fields to null.
            }
            isDisposed = true;
        }
        #endregion
    }
    public class Advert : IDisposable
    {
        public string advertiser;
        public string extension;
        public string webURL;
        public byte[] advertBinary;
        public Advert(string _advertiser)
        {
            List<SqlParameter> parameters = new List<SqlParameter>()
            {
                new SqlParameter("Advertiser", _advertiser)
            };

            DataTable dt = SQLcommands.ExecDataTable("GetAdvert", parameters);

            if (dt != null && dt.Rows.Count > 0)
            {
                extension = (string)dt.Rows[0]["extension"];
                webURL = (string)dt.Rows[0]["webURL"];
                advertiser = (string)dt.Rows[0]["advertiser"];
                advertBinary = (byte[])dt.Rows[0]["advertBinary"];
            }
            else
            {
                extension = "";
                advertiser = "";
                webURL = "";
                advertBinary = new byte[0];
            }

        }
        public static DataTable Adverts()
        {
            return SQLcommands.ExecDataTable("GetAdverts");
        }
        public void Merge()
        {
            List<SqlParameter> parameters = new List<SqlParameter>()
            {
                new SqlParameter("Advertiser", advertiser),
                new SqlParameter("extension", extension),
                new SqlParameter("webURL", webURL),
                new SqlParameter("advertBinary", SqlDbType.Binary)
            };
            parameters[3].Value = advertBinary;

            SQLcommands.ExecNonQuery("MergeAdvert", parameters);
        }
        public struct RandomAdverts
        {
            public int noAdverts;
            public DataTable advertisers;
            public int lastAdvert;
            public int advertCounter;
        }
        private static Int32 GenRandomInt(Int32 inMin, Int32 inMax)
        {
            System.Random generator = new System.Random();

            // ensure lowest is first
            if (inMin > inMax) { Int32 temp = inMin; inMin = inMax; inMax = temp; }

            // cope with max value (cannot add 1)
            if (inMax < Int32.MaxValue) { return generator.Next(inMin, inMax + 1); }

            // cope with min value 
            if (inMin < Int32.MinValue) { return generator.Next(inMin - 1, inMax) + 1; }

            // now min and max give full range of integer, but Random.Next() does not give us an option for the full range of integer.
            // so we need to use Random.NextBytes() to give us 4 random bytes, then convert that to our random int.
            byte[] bytes = new byte[3];
            generator.NextBytes(bytes);
            return BitConverter.ToInt32(bytes, 0);

        }
        public static RandomAdverts RandomiseAdverts()
        {
            DataTable advertisers = Advert.Adverts();
            DataTable randomisedAdvertisers = advertisers.Clone();

            while (advertisers.Rows.Count > 0)
            {
                int row = GenRandomInt(0, advertisers.Rows.Count - 1);
                DataRow newAdvertiser = randomisedAdvertisers.NewRow();

                newAdvertiser["Advertiser"] = advertisers.Rows[row]["Advertiser"];
                randomisedAdvertisers.Rows.Add(newAdvertiser);

                advertisers.Rows[row].Delete();
                advertisers.AcceptChanges();
            }

            RandomAdverts rAds = new RandomAdverts
            {
                noAdverts = advertisers.Rows.Count,
                advertisers = randomisedAdvertisers,
                lastAdvert = -1,
                advertCounter = 0
            };
            return rAds;
        }

        #region IDisposable implementation 
        private bool isDisposed = false;
        public void Dispose()
        {
            Dispose(true);
            GC.SuppressFinalize(this);
        }
        protected virtual void Dispose(bool disposing)
        {
            if (!isDisposed)
            {
                if (disposing)
                {
                    //TODO: dispose managed objects
                }
                //TODO: free unmanaged resources (unmanaged objects)
                //TODO: set large fields to null.
            }
            isDisposed = true;
        }
        #endregion

    }
    public class AwardsObj : IDisposable
    {
        public void Generate(int AwardType = 0)
        {
            List<SqlParameter> parameters = new List<SqlParameter>()
            {
                new SqlParameter("AwardType", AwardType)
            };

            SQLcommands.ExecNonQuery("Awards_GenerateWinners", parameters);

        }
        public DataTable Report(int AwardType)
        {
            List<SqlParameter> parameters = new List<SqlParameter>()
            {
                new SqlParameter("AwardType", AwardType)
            };

            return SQLcommands.ExecDataTable("Awards_Report_Static", parameters);
        }
        public void Insert(int AwardType
                        , string AwardID
                        , string SubID
                        , int LeagueID
                        , int EntrantID
                        , string Entrant2ID)
        {
            List<SqlParameter> parameters = new List<SqlParameter>()
            {
                new SqlParameter("AwardType", AwardType),
                new SqlParameter("LeagueID", LeagueID),
                new SqlParameter("EntrantID", EntrantID)
            };

            if (int.TryParse(AwardID, out int paramValue))
                parameters.Add(new SqlParameter("AwardID", paramValue));
            else
                parameters.Add(new SqlParameter("AwardID", DBNull.Value));
            if (int.TryParse(SubID, out paramValue))
                parameters.Add(new SqlParameter("SubID", paramValue));
            else
                parameters.Add(new SqlParameter("SubID", DBNull.Value));
            if (int.TryParse(Entrant2ID, out paramValue))
                parameters.Add(new SqlParameter("Entrant2ID", paramValue));

            SQLcommands.ExecNonQuery("Awards_insert", parameters);
        }
        public void Update(int AwardType
                        , string AwardID
                        , string SubID
                        , int LeagueID
                        , int EntrantID
                        , string Entrant2ID)
        {
            List<SqlParameter> parameters = new List<SqlParameter>()
            {
                new SqlParameter("AwardType", AwardType),
                new SqlParameter("LeagueID", LeagueID),
                new SqlParameter("EntrantID", EntrantID)
            };

            if (int.TryParse(AwardID, out int paramValue))
                parameters.Add(new SqlParameter("AwardID", paramValue));
            else
                parameters.Add(new SqlParameter("AwardID", DBNull.Value));
            if (int.TryParse(SubID, out paramValue))
                parameters.Add(new SqlParameter("SubID", paramValue));
            else
                parameters.Add(new SqlParameter("SubID", DBNull.Value));
            if (int.TryParse(Entrant2ID, out paramValue))
                parameters.Add(new SqlParameter("Entrant2ID", paramValue));

            SQLcommands.ExecNonQuery("Awards_update", parameters);

        }
        public void Delete(int AwardType
                        , string AwardID
                        , string SubID
                        , int LeagueID
                        , int EntrantID
    )
        {
            List<SqlParameter> parameters = new List<SqlParameter>()
            {
                new SqlParameter("AwardType", AwardType),
                new SqlParameter("LeagueID", LeagueID),
                new SqlParameter("EntrantID", EntrantID)
            };

            if (int.TryParse(AwardID, out int paramValue))
                parameters.Add(new SqlParameter("AwardID", paramValue));
            else
                parameters.Add(new SqlParameter("AwardID", DBNull.Value));
            if (int.TryParse(SubID, out paramValue))
                parameters.Add(new SqlParameter("SubID", paramValue));
            else
                parameters.Add(new SqlParameter("SubID", DBNull.Value));

            SQLcommands.ExecNonQuery("Awards_Delete", parameters);

        }
        public static List<string> GetSuggestedWinners(string prefixText, int count, int AwardType, int AwardID, int LeagueID)
        {
            List<string> suggestions = new List<string>();

            string[] TextWords = prefixText.Split(" ".ToCharArray());

            List<SqlParameter> parameters = new List<SqlParameter>()
            {
                new SqlParameter("AwardType", AwardType),
                new SqlParameter("AwardID", AwardID),
                new SqlParameter("LeagueID", LeagueID),
                new SqlParameter("count", count),
                new SqlParameter("word1", TextWords[0])
            };

            if (TextWords.Count() > 1)
            {
                parameters.Add(new SqlParameter("word2", TextWords[1]));
                if (TextWords.Count() > 2)
                    parameters.Add(new SqlParameter("word3", TextWords[2]));
            }

            DataTable dr = SQLcommands.ExecDataTable("SuggestAwardWinners", parameters);

            int ix = 0;
            while (ix < dr.Rows.Count && suggestions.Count < count) { 
                // This method sets up value, key (listitems) pairs for the autocomplete
                suggestions.Add(AjaxControlToolkit.AutoCompleteExtender.CreateAutoCompleteItem(dr.Rows[ix].ItemArray[0].ToString(), dr.Rows[ix].ItemArray[1].ToString()));
                ix += 1;
            }
            return suggestions;
        }
        #region IDisposable implementation 
        private bool disposedValue; // To detect redundant calls

        // IDisposable
        protected virtual void Dispose(bool disposing)
        {
            if (!disposedValue)
            {
                if (disposing)
                {
                }
            }
            disposedValue = true;
        }

        // TODO: override Finalize() only if Dispose(disposing As Boolean) above has code to free unmanaged resources.
        // Protected Overrides Sub Finalize()
        // ' Do not change this code.  Put cleanup code in Dispose(disposing As Boolean) above.
        // Dispose(False)
        // MyBase.Finalize()
        // End Sub

        // This code added by Visual Basic to correctly implement the disposable pattern.
        public void Dispose()
        {
            // Do not change this code.  Put cleanup code in Dispose(disposing As Boolean) above.
            Dispose(true);
        }
        #endregion
    }
    public class AwardsTemplate : IDisposable
    {
        public int AwardType;
        public object AwardID;
        public object SubID;
        public int LeagueID;
        public string Trophy;
        public string Award;
        public bool MultipleWinners;
        public string RecipientType;
        public string Competition;
        public string LeagueName;

        public AwardsTemplate()
        {
        }

        public AwardsTemplate(int _AwardType, string _AwardID, string _SubID, int _LeagueID)
        {
            GetAward(_AwardType, _AwardID, _SubID, _LeagueID);
        }

        public void GetAward(int _AwardType, string _AwardID, string _SubID, int _LeagueID)
        {
            List<SqlParameter> parameters = new List<SqlParameter>()
            {
                new SqlParameter("AwardType", _AwardType),
                new SqlParameter("LeagueID", _LeagueID)
            };

            if (int.TryParse(_AwardID, out int paramValue))
                parameters.Add(new SqlParameter("AwardID", paramValue));
            else
                parameters.Add(new SqlParameter("AwardID", DBNull.Value));
            if (int.TryParse(_SubID, out paramValue))
                parameters.Add(new SqlParameter("SubID", paramValue));
            else
                parameters.Add(new SqlParameter("SubID", DBNull.Value));


            DataTable dt = SQLcommands.ExecDataTable("Awards_TemplateData", parameters);
            while (dt != null && dt.Rows.Count > 0)
            {
                AwardType = (int)dt.Rows[0]["AwardType"];
                AwardID = DBNull.Value == dt.Rows[0]["AwardID"] ? null : dt.Rows[0]["AwardID"];
                SubID = DBNull.Value == dt.Rows[0]["SubID"] ? null : dt.Rows[0]["SubID"];
                LeagueID = (int)dt.Rows[0]["LeagueID"];
                Trophy = DBNull.Value == dt.Rows[0]["Trophy"] ? "" : (string)dt.Rows[0]["Trophy"];
                Award = (string)dt.Rows[0]["Award"];
                MultipleWinners = (bool)dt.Rows[0]["MultipleWinners"];
                Competition = (string)dt.Rows[0]["Competition"];
                LeagueName = (string)dt.Rows[0]["League Name"];
                RecipientType = (string)dt.Rows[0]["RecipientType"];
            }
        }

        public void Create()
        {
            List<SqlParameter> parameters = new List<SqlParameter>()
            {
                new SqlParameter("AwardType", AwardType),
                new SqlParameter("LeagueID", LeagueID),
                new SqlParameter("Trophy", Trophy),
                new SqlParameter("Award", Award),
                new SqlParameter("MultipleWinners", MultipleWinners),
                new SqlParameter("RecipientType", RecipientType)
            };

            if (int.TryParse((string)AwardID, out int paramValue))
                parameters.Add(new SqlParameter("AwardID", paramValue));
            else
                parameters.Add(new SqlParameter("AwardID", DBNull.Value));
            if (int.TryParse((string)SubID, out paramValue))
                parameters.Add(new SqlParameter("SubID", paramValue));
            else
                parameters.Add(new SqlParameter("SubID", DBNull.Value));

            SQLcommands.ExecNonQuery("Awards_TemplateCreate", parameters);

            // complete the object public fields
            GetAward(AwardType, (string)AwardID, (string)SubID, LeagueID);

        }
        public void Update()
        {
            List<SqlParameter> parameters = new List<SqlParameter>()
            {
                new SqlParameter("AwardType", AwardType),
                new SqlParameter("LeagueID", LeagueID),
                new SqlParameter("Trophy", Trophy),
                new SqlParameter("Award", Award),
                new SqlParameter("MultipleWinners", MultipleWinners),
                new SqlParameter("RecipientType", RecipientType)
            };

            if (int.TryParse((string)AwardID, out int paramValue))
                parameters.Add(new SqlParameter("AwardID", paramValue));
            else
                parameters.Add(new SqlParameter("AwardID", DBNull.Value));
            if (int.TryParse((string)SubID, out paramValue))
                parameters.Add(new SqlParameter("SubID", paramValue));
            else
                parameters.Add(new SqlParameter("SubID", DBNull.Value));

            SQLcommands.ExecNonQuery("Awards_TemplateUpdate", parameters);

        }
        public string Delete(bool Override = false)
        {
            List<SqlParameter> parameters = new List<SqlParameter>()
            {
                new SqlParameter("AwardType", AwardType),
                new SqlParameter("LeagueID", LeagueID),
            };

            if (int.TryParse((string)AwardID, out int paramValue))
                parameters.Add(new SqlParameter("AwardID", paramValue));
            else
                parameters.Add(new SqlParameter("AwardID", DBNull.Value));
            if (int.TryParse((string)SubID, out paramValue))
                parameters.Add(new SqlParameter("SubID", paramValue));
            else
                parameters.Add(new SqlParameter("SubID", DBNull.Value));
            if (Override)
                parameters.Add(new SqlParameter("Override", Override));
            try
            {
                SQLcommands.ExecNonQuery("Awards_TemplateDelete", parameters);
                return LeagueName + ", " + Competition + " deleted";
            }
            catch (Exception ex)
            {
                if (ex.Message.ToLower().Contains("there is a linked award"))
                    return LeagueName + ", " + Competition + " has a recipient." + ex.Message;
                else
                    return ex.Message;
            }
        }

        public static DataTable AvailableAwards(bool AllAwards = false)
        {
            return SQLcommands.ExecDataTable("Awards_AvailableAwards", new List<SqlParameter>() { new SqlParameter("AllAwards", AllAwards) });
        }

        public static DataRow GetBreaksCategory(int BreakID)
        {
            return SQLcommands.ExecDataTable("GetBreaksCategory", new List<SqlParameter>() { new SqlParameter("BreakID", BreakID) }).Rows[0];
        }

        public static DataTable GetBreaksCategories(bool WithLimits = false, int LeagueID = 0)
        {
            string commandText = "GetBreaksCategories";
            if (WithLimits)
                commandText += "2";
            return SQLcommands.ExecDataTable(commandText, new List<SqlParameter>() { new SqlParameter("LeagueID", LeagueID) });
        }
        public static DataTable AwardTypes()
        {
            return SQLcommands.ExecDataTable("Award_Types");
        }

        public static string CompetitionName(int _AwardType, object _AwardID, object _SubID, int _LeagueID)
        {
            List<SqlParameter> parameters = new List<SqlParameter>()
            {
                new SqlParameter("AwardType", _AwardType),
                new SqlParameter("LeagueID", _LeagueID),
            };

            if (int.TryParse((string)_AwardID, out int paramValue))
                parameters.Add(new SqlParameter("AwardID", paramValue));
            else
                parameters.Add(new SqlParameter("AwardID", DBNull.Value));
            if (int.TryParse((string)_SubID, out paramValue))
                parameters.Add(new SqlParameter("SubID", paramValue));
            else
                parameters.Add(new SqlParameter("SubID", DBNull.Value));

            SqlParameter Result = new SqlParameter("@Result", SqlDbType.VarChar)
            {
                Direction = ParameterDirection.ReturnValue
            };
            parameters.Add(Result);

            object result = SQLcommands.ExecScalar("dbo.Awards_TemplateCompetition", parameters);

            if (result != DBNull.Value)
                return (string)result;
            else
                return "";
        }
        public static string warningMsg;
        public static string UpdateBreakCategory(int LeagueID, int ID, int Handicap, string HighOrLow)
        {
            List<SqlParameter> parameters = new List<SqlParameter>()
            {
                new SqlParameter("LeagueID", LeagueID),
                new SqlParameter("ID", ID),
                new SqlParameter("Handicap", Handicap)
            };

            warningMsg = "";  //this may be changed by a warning from the SQL procedure 
                              //which will cause an event which in turn will invoke "updateBreakCategoryWarning"

            SQLcommands.ExecNonQuery("UpdateBreaksCategories" + HighOrLow, parameters, UpdateBreakCategoryWarning);

            return warningMsg;
        }
        public static void UpdateBreakCategoryWarning(object sender, System.Data.SqlClient.SqlInfoMessageEventArgs e)
        {
            warningMsg = e.Message;
        }

        public static void DeleteBreakCategory(int LeagueID, int ID)
        {
            List<SqlParameter> parameters = new List<SqlParameter>()
            {
                new SqlParameter("LeagueID", LeagueID),
                new SqlParameter("ID", ID),
            };

            SQLcommands.ExecNonQuery("DeleteBreakCategory", parameters);
        }

        public static void InsertBreakCategory(int LeagueID, int ID)
        {
            List<SqlParameter> parameters = new List<SqlParameter>()
            {
                new SqlParameter("LeagueID", LeagueID),
                new SqlParameter("ID", ID),
            };

            SQLcommands.ExecNonQuery("InsertBreakCategory", parameters);
        }
        #region disposable
        private bool disposedValue; // To detect redundant calls

        // IDisposable
        protected virtual void Dispose(bool disposing)
        {
            if (!disposedValue)
            {
                if (disposing)
                {
                }
            }
            disposedValue = true;
        }

        // TODO: override Finalize() only if Dispose(disposing As Boolean) above has code to free unmanaged resources.
        // Protected Overrides Sub Finalize()
        // ' Do not change this code.  Put cleanup code in Dispose(disposing As Boolean) above.
        // Dispose(False)
        // MyBase.Finalize()
        // End Sub

        // This code added by Visual Basic to correctly implement the disposable pattern.
        public void Dispose()
        {
            // Do not change this code.  Put cleanup code in Dispose(disposing As Boolean) above.
            Dispose(true);
        }
        #endregion
    }
    public class AwardsType : IDisposable
    {
        public int AwardType;
        public string Name;
        public string Description;
        public string StoredProcedureName;
        public AwardsType()
        {
        }
        public AwardsType(int _AwardType)
        {
            GetAwardType(_AwardType);
        }
        public void GetAwardType(int _AwardType)
        {
            List<SqlParameter> parameters = new List<SqlParameter>()
            {
                new SqlParameter("AwardType", _AwardType)
            };

            DataTable dt = SQLcommands.ExecDataTable("Awards_TypeData", parameters);
            if (dt != null && dt.Rows.Count > 0)
            {
                AwardType = (int)dt.Rows[0]["AwardType"];
                Name = (string)dt.Rows[0]["Name"];
                Description = (string)dt.Rows[0]["Description"];
                StoredProcedureName = DBNull.Value == dt.Rows[0]["StoredProcedureName"] ? "" : (string)dt.Rows[0]["StoredProcedureName"];
            }

        }
        public void Create()
        {
            List<SqlParameter> parameters = new List<SqlParameter>()
            {
                new SqlParameter("Name", Name),
                new SqlParameter("Description", Description),
            };
            if (StoredProcedureName == "")
                parameters.Add(new SqlParameter("StoredProcedureName", DBNull.Value));
            else
                parameters.Add(new SqlParameter("StoredProcedureName", StoredProcedureName));

            SQLcommands.ExecNonQuery("Awards_TypeCreate", parameters);

            // complete this object's public fields
            GetAwardType(AwardType);
        }
        public void Update()
        {
            List<SqlParameter> parameters = new List<SqlParameter>()
            {
                new SqlParameter("AwardType", AwardType),
                new SqlParameter("Name", Name),
                new SqlParameter("Description", Description),
            };
            if (StoredProcedureName == "")
                parameters.Add(new SqlParameter("StoredProcedureName", DBNull.Value));
            else
                parameters.Add(new SqlParameter("StoredProcedureName", StoredProcedureName));

            SQLcommands.ExecNonQuery("Awards_TypeUpdate", parameters);

        }
        public string Delete(bool Override = false)
        {
            List<SqlParameter> parameters = new List<SqlParameter>()
            {
                new SqlParameter("AwardType", AwardType),
            };
            if (Override)
                parameters.Add(new SqlParameter("Override", Override));

            try
            {
                SQLcommands.ExecNonQuery("Awards_TypeDelete", parameters);
                return "AwardType " + AwardType + ", " + Name + " deleted";
            }
            catch (Exception ex)
            {
                return ex.Message;
            }
        }
        public static DataTable Types()
        {
            return SQLcommands.ExecDataTable("Awards_TypesDetails");
        }

        #region "IDisposable Support"

        private bool disposedValue; // To detect redundant calls

        // IDisposable
        protected virtual void Dispose(bool disposing)
        {
            if (!disposedValue)
            {
                if (disposing)
                {
                }
            }
            disposedValue = true;
        }

        // TODO: override Finalize() only if Dispose(disposing As Boolean) above has code to free unmanaged resources.
        // Protected Overrides Sub Finalize()
        // ' Do not change this code.  Put cleanup code in Dispose(disposing As Boolean) above.
        // Dispose(False)
        // MyBase.Finalize()
        // End Sub

        // This code added by Visual Basic to correctly implement the disposable pattern.
        public void Dispose()
        {
            // Do not change this code.  Put cleanup code in Dispose(disposing As Boolean) above.
            Dispose(true);
        }
        #endregion
    }
    public class ClubData : IDisposable
    {
        public int ID;
        public string ClubName;
        public string Address1;
        public string Address2;
        public string PostCode;
        public string ContactName;
        public string ClubLoginEMail;
        public string ContactTelNo;
        public string ContactMobNo;
        public int MatchTables;
        public DataTable Teams;
        public DataTable Players;

        public ClubData() { }
        public ClubData(int ClubID)
        {
            GetClubData(ClubID);
        }
        public void GetClubData(int ClubID)
        {
            List<SqlParameter> parameters = new List<SqlParameter>()
            {
                new SqlParameter("ID", ClubID)
            };

            DataSet ds = SQLcommands.ExecDataSet("ClubRecord", parameters);

            if (ds != null && ds.Tables.Count > 0)
            {
                if (ds.Tables[0] != null && ds.Tables[0].Rows.Count > 0)
                {
                    DataRow clubRow = ds.Tables[0].Rows[0];
                    ID = (int)clubRow["ID"];
                    ClubName = (string)clubRow["Club Name"];
                    Address1 = (string)clubRow["Address1"];
                    Address2 = (string)clubRow["Address2"];
                    PostCode = (string)clubRow["PostCode"];
                    ContactName = (string)clubRow["ContactName"];
                    ClubLoginEMail = (string)clubRow["ClubLoginEMail"];
                    ContactTelNo = (string)clubRow["ContactTelNo"];
                    ContactMobNo = (string)clubRow["ContactMobNo"];
                    MatchTables = DBNull.Value == clubRow["MatchTables"] ? 0 :(int)clubRow["MatchTables"];
                }

                Teams = ds.Tables[1];
                Players = ds.Tables[2];
            }
        }
        public string Merge()
        {
            List<SqlParameter> parameters = new List<SqlParameter>()
            {
                new SqlParameter("ClubID", ID),
                new SqlParameter("ClubName", ClubName),  // Note that if this is zero length string it will delete the Club with the given ID
                new SqlParameter("Address1", Address1),
                new SqlParameter("Address2", Address2),
                new SqlParameter("PostCode", PostCode),
                new SqlParameter("ContactName", ContactName),
                new SqlParameter("ContactTelNo", ContactTelNo),
                new SqlParameter("ContactMobNo", ContactMobNo),
                new SqlParameter("MatchTables", MatchTables),
            };

            return (string)SQLcommands.ExecScalar("MergeClub", parameters);

        }
        public static DataTable GetAllClubs ()
        {
            return SQLcommands.ExecDataTable("GetAllClubs");
        }
        public static DataTable GetClubs(int SectionID = 0, bool includeBye = false)
        {
            List<SqlParameter> parameters = new List<SqlParameter>()
            {
                new SqlParameter("SectionID", SectionID),
                new SqlParameter("IncludeBye", includeBye)
            };

            return SQLcommands.ExecDataTable("GetClubs", parameters);
        }
        public static DataSet ClubDetails(int ClubID, bool forMobile = false)
        {
            List<SqlParameter> parameters = new List<SqlParameter>()
            {
                new SqlParameter("ID", ClubID),
                new SqlParameter("forMobile",forMobile)
            };

            return SQLcommands.ExecDataSet("ClubDetails", parameters);
        }
        public static DataRow GetEMailAddresses(int LeagueID, int SectionID)
        {
            List<SqlParameter> parameters = new List<SqlParameter>()
            {
                new SqlParameter("LeagueID", LeagueID),
                new SqlParameter("SectionID", SectionID)
            };

            return SQLcommands.ExecDataTable("ClubEMailAddresses", parameters).Rows[0];
        }

        #region "IDisposable support"
        private bool disposedValue = false;        // To detect redundant calls

        // IDisposable
        protected virtual void Dispose(bool disposing)
        {
            if (!this.disposedValue)
            {
                if (disposing)
                {
                }
            }
            this.disposedValue = true;
        }
        // This code added by Visual Basic to correctly implement the disposable pattern.
        public void Dispose()
        {
            // Do not change this code.  Put cleanup code in Dispose(ByVal disposing As Boolean) above.
            Dispose(true);
            GC.SuppressFinalize(this);
        }
        #endregion
    }
    public class ClubUserData : IDisposable
    {
        public bool loggedIn;
        public int ClubID;
        public string eMail;
        private string _Password = "";
        public string Password
        {
            set
            {
                _Password = value;
            }
        }
        private string HashedPassword;
        public bool Confirmed;
        public string ConfirmationCode;
        public string FirstName;
        public string Surname;
        public string Telephone;
        public string ClubName;

        public ClubUserData()
        {
        }
        public ClubUserData(int _ClubID, string eMailAddress = "")
        {
            GetClubUserData(eMailAddress, "", _ClubID);
        }
        public ClubUserData(string eMailAddress, string _Password)
        {
            GetClubUserData(eMailAddress, _Password, 0);
        }
        public void GetClubUserData(string eMailAddress, string _Password, int _ClubID)
        {
            List<SqlParameter> parameters = new List<SqlParameter>();
            if (_ClubID == 0)
            {
                parameters.Add(new SqlParameter("eMailAddress", eMailAddress));
                parameters.Add(new SqlParameter("Password", HBSAcodeLibrary.Utilities.RFC2898_Hash(_Password)));
            }
            else
            {
                parameters.Add(new SqlParameter("ClubID", _ClubID));
                if (eMailAddress != "")
                    parameters.Add(new SqlParameter("eMailAddress", eMailAddress));
            }

            DataTable clubDataTable = SQLcommands.ExecDataTable("checkClubLogin", parameters);

            if (clubDataTable != null && clubDataTable.Rows.Count > 0)
            {
                ClubID = (int)clubDataTable.Rows[0]["ClubID"];
                eMail = (string)clubDataTable.Rows[0]["eMailAddress"];
                HashedPassword = (string)clubDataTable.Rows[0]["Password"];
                ConfirmationCode = (string)clubDataTable.Rows[0]["Confirmed"];
                Confirmed = ((string)clubDataTable.Rows[0]["Confirmed"] == "Confirmed");
                FirstName = (string)clubDataTable.Rows[0]["FirstName"];
                Surname = (string)clubDataTable.Rows[0]["Surname"];
                Telephone = (string)clubDataTable.Rows[0]["Telephone"];
                ClubName = (string)clubDataTable.Rows[0]["Club Name"];

                loggedIn = true;
            }
            else
                loggedIn = false;

        }
        public void MergeClubUser()
        {
            List<SqlParameter> parameters = new List<SqlParameter>()
            {
                new SqlParameter("eMailAddress", eMail),
                new SqlParameter("ClubID", ClubID),
                new SqlParameter("Confirmed", ConfirmationCode),
                new SqlParameter("FirstName", FirstName),
                new SqlParameter("Surname", Surname),
                new SqlParameter("Telephone", Telephone)
           };
            if (_Password != "")
                parameters.Add(new SqlParameter("Password", HBSAcodeLibrary.Utilities.RFC2898_Hash(_Password)));

            SQLcommands.ExecNonQuery("MergeClubUser", parameters);

        }
        public void ConfirmClubUser()
        {
            List<SqlParameter> parameters = new List<SqlParameter>()
            {
                new SqlParameter("eMailAddress", eMail),
                new SqlParameter("Password", HashedPassword),
                new SqlParameter("ConfirmCode", ConfirmationCode)
            };

            SQLcommands.ExecNonQuery("ConfirmClubLogin", parameters);
            ConfirmationCode = "Confirmed";
        }
        public static DataRow ClubLoginData(int ClubID)
        {
            List<SqlParameter> parameters = new List<SqlParameter>()
            {
                new SqlParameter("ClubID", ClubID)
            };

            return SQLcommands.ExecDataTable("ClubLoginDetails", parameters).Rows[0];

        }
        public static void ClubLoginPasswordReset(int ClubID, string Password)
        {
            List<SqlParameter> parameters = new List<SqlParameter>()
            {
                new SqlParameter("Password", Password),
                new SqlParameter("ClubID", ClubID)
            };

            SQLcommands.ExecNonQuery("ClubLoginPasswordReset", parameters);

        }
        public static DataTable ClubsAndUsers()
        {
            return SQLcommands.ExecDataTable("ClubsAndUsers");
        }
        #region "IDisposable Support"    

        private bool disposedValue = false;        // To detect redundant calls

        // IDisposable
        protected virtual void Dispose(bool disposing)
        {
            if (!this.disposedValue)
            {
                if (disposing)
                {
                }
            }
            this.disposedValue = true;
        }

        // This code added by Visual Basic to correctly implement the disposable pattern.
        public void Dispose()
        {
            // Do not change this code.  Put cleanup code in Dispose(ByVal disposing As Boolean) above.
            Dispose(true);
            GC.SuppressFinalize(this);
        }
        #endregion
    }
    public enum CompetitionType
    {
        Open = 1,
        Handicaps = 2,
        Pairs = 3,
        Teams = 4
    }
    public class CompetitionData : IDisposable
    {
        public int ID;
        public string Name;
        public int LeagueID;
        public CompetitionType competitionType;
        public int NoRounds;
        public string Comment;
        public bool EntryForm;
        public decimal EntryFee;
        public bool Drawn;
        public CompetitionData()
        {
        }
        public CompetitionData(int CompetitionID)
        {
            List<SqlParameter> parameters = new List<SqlParameter>()
            {
                new SqlParameter("ID", CompetitionID)
            };

            DataTable dt = SQLcommands.ExecDataTable("CompetitionDetails", parameters);

            if (dt != null && dt.Rows.Count > 0)
            {
                DataRow dr = dt.Rows[0];
                ID = (int)dr["ID"];
                Name = (string)dr["Name"];
                LeagueID = (int)dr["LeagueID"];
                competitionType = (CompetitionType)dr["CompType"];
                NoRounds = DBNull.Value == dr["NoRounds"] ? 0 : (int)dr["NoRounds"];
                Comment = DBNull.Value == dr["Comment"] ? "" : (string)dr["Comment"];
                EntryForm = DBNull.Value != dr["EntryForm"] && Convert.ToBoolean(dr["EntryForm"]);
                EntryFee = DBNull.Value == dr["EntryFee"] ? 0 : (decimal)dr["EntryFee"];
                Drawn = (NoRounds > 0);
            }

        }
        public void Update()
        {
            List<SqlParameter> parameters = new List<SqlParameter>()
            {
                new SqlParameter("CompetitionID", ID),
                new SqlParameter("Name", Name),
                new SqlParameter("LeagueID", LeagueID),
                new SqlParameter("CompType", competitionType),
                new SqlParameter("Comment", Comment),
                new SqlParameter("EntryForm", EntryForm),
                new SqlParameter("EntryFee", EntryFee),
            };

            SQLcommands.ExecNonQuery("UpdateCompetition", parameters);
        }
        public void Insert()
        {
            List<SqlParameter> parameters = new List<SqlParameter>()
            {
                new SqlParameter("Name", Name),
                new SqlParameter("LeagueID", LeagueID),
                new SqlParameter("CompType", competitionType),
                new SqlParameter("Comment", Comment),
                new SqlParameter("EntryForm", EntryForm),
                new SqlParameter("EntryFee", EntryFee),
            };

            SQLcommands.ExecNonQuery("NewCompetition", parameters);
        }
        public void Delete()
        {
            List<SqlParameter> parameters = new List<SqlParameter>()
            {
                new SqlParameter("CompetitionID", ID),
            };

            SQLcommands.ExecNonQuery("DeleteCompetition", parameters);
        }
        public void DeleteEntry(int EntryID)
        {
            List<SqlParameter> parameters = new List<SqlParameter>()
            {
                new SqlParameter("CompetitionID", ID),
                new SqlParameter("EntryID", EntryID)
            };

            SQLcommands.ExecNonQuery("DeleteCompetitionEntry", parameters);
        }
        public void Clear(object FromRound = null)
        {
            List<SqlParameter> parameters = new List<SqlParameter>()
            {
                new SqlParameter("CompetitionID", ID),
            };
            if (FromRound != null)
                parameters.Add(new SqlParameter("FromRound", System.Convert.ToInt32(FromRound)));

            SQLcommands.ExecNonQuery("ClearCompetition", parameters);
        }
        public void Make1stRound()
        {
            List<SqlParameter> parameters = new List<SqlParameter>()
            {
                new SqlParameter("CompetitionID", ID),
            };

            SQLcommands.ExecNonQuery("MakeCompetition1stRound", parameters);
        }
        public void MakeDraw()
        {
            List<SqlParameter> parameters = new List<SqlParameter>()
            {
                new SqlParameter("CompetitionID", ID),
            };

            SQLcommands.ExecNonQuery("MakeCompetitionDraw", parameters);
        }
        public DataTable ApplyCompetitionEntryEntryForms()
        {
            return SQLcommands.ExecDataTable("ApplyCompetitionEntryForms");
        }
        public DataSet PotentialEntrants(int ClubID, bool ALL, int SortBy)
        {    //get players that are not already in the competition, and are on the entry form
            List<SqlParameter> parameters = new List<SqlParameter>()
            {
                new SqlParameter("CompetitionID", ID),
                new SqlParameter("ClubID", ClubID),
                new SqlParameter("ALL", ALL),
                new SqlParameter("SortBy", SortBy)
            };

            return SQLcommands.ExecDataSet("CompetitionPotentialEntrants", parameters);
        }
        public DataTable CompetitionEntrants()
        {   //get any players that are not already in the competition
            return SQLcommands.ExecDataTable("GetCompetitionEntrants", new List<SqlParameter> { 
                                                                     new SqlParameter("CompetitionID", ID) });

        }
        public DataTable CompetitionEntries()
        {   //get any players that are not already in the competition
            return SQLcommands.ExecDataTable("GetCompetitionEntries", new List<SqlParameter> {
                                                                          new SqlParameter("CompetitionID", ID) });

        }
        public void PromoteCompetitionEntry(int entryID, int roundNo)
        {
            SQLcommands.ExecNonQuery("PromoteCompetitionEntry", new List<SqlParameter> {
                                                                    new SqlParameter("CompetitionID", ID), 
                                                                    new SqlParameter("EntryId", entryID),
                                                                    new SqlParameter("RoundNo", roundNo) });
        }
        public void RemoveCompetitionEntry(int entryID, int roundNo)
        {
            SQLcommands.ExecNonQuery("RemoveCompetitionEntry", new List<SqlParameter> {
                                                                    new SqlParameter("CompetitionID", ID),
                                                                    new SqlParameter("EntryId", entryID),
                                                                    new SqlParameter("RoundNo", roundNo) });
        }
        public void CompetitionEntryFormMerge(int ClubID, int EntrantID, int Entrant2ID = 0)
        {
            List<SqlParameter> parameters = new List<SqlParameter>()
            {
                new SqlParameter("CompetitionID", ID),
                new SqlParameter("ClubID", ClubID),
                new SqlParameter("EntrantID", EntrantID),
            };
            if (competitionType == CompetitionType.Pairs || Entrant2ID < 0)  //Entrant2 as -1 implies delete
                parameters.Add(new SqlParameter("Entrant2ID", Entrant2ID));

            SQLcommands.ExecNonQuery("CompetitionEntryFormMerge", parameters);
        }
        public void MergeCompetitionEntry(int entryID, int entrantID, int entrant2ID)
        {
            List<SqlParameter> parameters = new List<SqlParameter> 
            {
                new SqlParameter("CompetitionID",ID),
                new SqlParameter("EntryID", entryID),
                new SqlParameter("EntrantID", entrantID)
            };
            if (competitionType == CompetitionType.Pairs)
                parameters.Add(new SqlParameter("Entrant2ID", entrant2ID));

            SQLcommands.ExecNonQuery("MergeCompetitionEntry", parameters);
        }
        public bool IsQualified(int EntrantID)
        {
            using (HBSA_Configuration cfg = new HBSA_Configuration())
            {

                if (competitionType != CompetitionType.Teams)
                {

                    DataRow dr = SQLcommands.ExecDataTable("QualifyingMatchesPlayed",
                                                            new List<SqlParameter>() { new SqlParameter("PlayerID", EntrantID) })
                                      .Rows[0];
                    if (Convert.ToBoolean(dr["NewRegistration"]))
                        return ((int)dr["Played"] >= Convert.ToInt16(cfg.Value("EntryFormNoQualifyingMatchesNewReg")));
                    else
                        return ((int)dr["Played"] >= Convert.ToInt16(cfg.Value("EntryFormNoQualifyingMatches")));

                }
                else
                    return true;
            }
        }
        public static DataTable GetCompetitions()
        {
            return SQLcommands.ExecDataTable("GetCompetitionsList");
        }
        public static DataTable GetCompetitions(int drawn)
        {
            return SQLcommands.ExecDataTable("GetCompetitions", 
                               new List<SqlParameter> { new SqlParameter("Drawn", drawn) });
        }
        public static void ClearAllCompetitions()
        {
            SQLcommands.ExecNonQuery("ClearCompetitions");
        }
        public static DataTable EntrantsReport(int competitionID)
        {
            return SQLcommands.ExecDataTable("Competitions_EntrantsReport",
                                              new List<SqlParameter> { new SqlParameter("CompetitionID", competitionID) });
        }
        #region "IDisposable
        private bool disposedValue = false;        // To detect redundant calls

        // IDisposable
        protected virtual void Dispose(bool disposing)
        {
            if (!this.disposedValue)
            {
                if (disposing)
                {
                }
            }
            this.disposedValue = true;
        }
        // This code added by Visual Basic to correctly implement the disposable pattern.
        public void Dispose()
        {
            // Do not change this code.  Put cleanup code in Dispose(ByVal disposing As Boolean) above.
            Dispose(true);
            GC.SuppressFinalize(this);
        }
        #endregion
    }
    public class CompetitionEntryFormData : IDisposable
    {
        public enum WIP
        {
            NotEntered,
            InProgress,
            Submitted,
            Fixed
        }

        public string ClubName;
        public int ClubID;
        public WIP State;
        public decimal AmountPaid;
        public decimal EntryFormFee;
        public DataTable Payments;
        public bool privacyAccepted;
        public CompetitionEntryFormData(int _ClubID)
        {
            List<SqlParameter> parameters = new List<SqlParameter>()
            {
                new SqlParameter("ClubID", _ClubID)
            };

            DataSet ds = SQLcommands.ExecDataSet("Competitions_GetEntryForm", parameters);

            if (ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0)
            {
                ClubName = (string)ds.Tables[0].Rows[0]["ClubName"];
                ClubID = (int)ds.Tables[0].Rows[0]["ClubID"];
                State = (WIP)ds.Tables[0].Rows[0]["WIP"];
                EntryFormFee = (decimal)ds.Tables[0].Rows[0]["EntryFee"];
                AmountPaid = (decimal)ds.Tables[0].Rows[0]["AmountPaid"];
                privacyAccepted = (bool)ds.Tables[0].Rows[0]["privacyAccepted"];

                if (ds.Tables.Count > 1 && ds.Tables[1].Rows.Count > 0)
                    Payments = ds.Tables[1];
            }
            else
            {
                ClubID = _ClubID;
                State = WIP.NotEntered;
            }
        }
        public void MergeClubData()
        {
            List<SqlParameter> parameters = new List<SqlParameter>()
            {
                new SqlParameter("ClubID", ClubID),
                new SqlParameter("WIP", State),
                new SqlParameter("privacyAccepted", privacyAccepted)
            };

            SQLcommands.ExecNonQuery("CompetitionEntryForm_MergeClubData", parameters);
        }
        public static DataTable FullReport(int ClubID)
        {
            List<SqlParameter> parameters = new List<SqlParameter>()
            {
                new SqlParameter("ClubID", ClubID)
            };

            return SQLcommands.ExecDataTable("Competitions_Report", parameters);
        }
        public static DataTable ClubsSummaryReport(WIP State)
        {
            List<SqlParameter> parameters = new List<SqlParameter>()
            {
                new SqlParameter("WIP", State)
            };

            return SQLcommands.ExecDataTable("CompetitionEntryForm_SummaryReport", parameters);
        }
        public static void ClearCompetitionsEntryForms()
        {
            SQLcommands.ExecNonQuery("CompetitionEntryForm_ClearAll");
        }
        #region "IDisposable"
        private bool disposedValue = false;        // To detect redundant calls

        // IDisposable
        protected virtual void Dispose(bool disposing)
        {
            if (!this.disposedValue)
            {
                if (disposing)
                {
                }
            }
            this.disposedValue = true;
        }
        // This code added by Visual Basic to correctly implement the disposable pattern.
        public void Dispose()
        {
            // Do not change this code.  Put cleanup code in Dispose(ByVal disposing As Boolean) above.
            Dispose(true);
            GC.SuppressFinalize(this);
        }
        #endregion
    }
    public class CompetitionRounds : IDisposable
    {
        public DataSet CompetitionDetailsData = new DataSet();
        // This dataset contains a table for each round.  A table will be empty until an entrant has been promoted into that round
        public struct RoundHeader
        {
            public int RoundNo;
            public string PlayByDate;
            public string Comment;
        }
        public struct Entrant
        {
            public string name;
            public string eMail;
            public string TelNo;
        }
        public CompetitionRounds()
        {
        }
        public CompetitionRounds(int competitionID)
        {
            GetCompetitionData(competitionID);
        }
        public void GetCompetitionData(int competitionID)
        {
            List<SqlParameter> parameters = new List<SqlParameter>()
            {
                new SqlParameter("CompetitionID", competitionID)
            };
            CompetitionDetailsData = SQLcommands.ExecDataSet("GetCompetitionDetails", parameters);
        }
        public static void UpdateCompetitionEntryID(int competitionID, int DrawID, int EntryId)
        {
            List<SqlParameter> parameters = new List<SqlParameter>
            {
                new SqlParameter("CompetitionID", competitionID),
                new SqlParameter("DrawID", DrawID),
                new SqlParameter("EntryId", EntryId)
            };
            SQLcommands.ExecNonQuery("UpdateCompetitionEntryID", parameters);
        }
        public static DataTable GetCompetitionRound1Data(int competitionID)
        {
            List<SqlParameter> parameters = new List<SqlParameter>
            {
                new SqlParameter("CompetitionID", competitionID),
            };

            return SQLcommands.ExecDataTable("GetCompetitionRound1Data", parameters);
        }
        public string CompetitionComment(int competitionID)
        {
            List<SqlParameter> parameters = new List<SqlParameter>
            {
                new SqlParameter("ID", competitionID)
            };

            object comment = SQLcommands.ExecDataTable("CompetitionDetails", parameters).Rows[0]["Comment"];
            return DBNull.Value == comment ? "" : (string)comment;
        }
        public Entrant EntrantDetail(int RoundIx, int EntryID)
        {
            Entrant EntrantData;

            if (RoundIx < CompetitionDetailsData.Tables.Count - 1)
            {
                DataRow[] EntryDetails = CompetitionDetailsData.Tables[RoundIx].Select("EntryID = " + System.Convert.ToString(EntryID));
                if (EntryDetails.Length > 0)
                {
                    EntrantData.name = EntryDetails[0].Field<string>("Entrant");
                    if (EntryDetails[0]["Entrant2"] != System.DBNull.Value)
                    {
                        if (EntryDetails[0].Field<string>("Entrant2").Length > 0)
                            EntrantData.name += "<br/>" + EntryDetails[0].Field<string>("Entrant2");
                    }

                    EntrantData.eMail = EntryDetails[0]["eMail"] == System.DBNull.Value ? "" : EntryDetails[0].Field<string>("eMail");
                    EntrantData.TelNo = EntryDetails[0]["TelNo"] == System.DBNull.Value ? "" : EntryDetails[0].Field<string>("TelNo");
                }
                else
                    EntrantData = default;  //effectively returns null
            }
            else
                EntrantData = default;  //effectively returns null

            return EntrantData;
        }
        public RoundHeader GetRoundHeader(int RoundIx)
        {
            RoundHeader header;
            DataRow[] RoundHeaderRow = CompetitionDetailsData.Tables[CompetitionDetailsData.Tables.Count - 1].Select("RoundNo = " + System.Convert.ToString(RoundIx));

            header.RoundNo = (int)RoundIx;

            header.PlayByDate = RoundHeaderRow[0]["PlayBydate"] == DBNull.Value  //IsDBNull(RoundHeaderRow[0].Item("PlayBydate")) 
                                    ? ""
                                    : (RoundHeaderRow[0].Field<DateTime>("PlayBydate")).ToString("dd MMM yyyy");
            header.Comment = RoundHeaderRow[0]["Comment"] == DBNull.Value
                                    ? ""
                                    : RoundHeaderRow[0].Field<string>("Comment");
            return header;
        }
        public string Notes(int RoundNo, int EntryID, int competitionID, bool admin = false)
        {
            List<SqlParameter> parameters = new List<SqlParameter>
            {
                new SqlParameter("CompetitionID", competitionID),
                new SqlParameter("RoundNo", RoundNo),
                new SqlParameter("EntryID", EntryID)
            };
            if (admin)
                parameters.Add(new SqlParameter("Admin", admin));

            return (string)SQLcommands.ExecScalar("GetCompetitionNote", parameters);
        }
        public static void MergeNote(int competitionID, int RoundNo, DateTime PlayByDate, string comment)
        {
            List<SqlParameter> parameters = new List<SqlParameter>
            {
                new SqlParameter("CompetitionID", competitionID),
                new SqlParameter("RoundNo", RoundNo),
                new SqlParameter("Comment", comment)
            };
            if (PlayByDate != new DateTime(2001, 1, 1))
                parameters.Add(new SqlParameter("PlayByDate", PlayByDate));
            else
                parameters.Add(new SqlParameter("PlayByDate", DBNull.Value));

            SQLcommands.ExecNonQuery("MergeCompetitionNote", parameters);
        }
        public static void MergeNote(int competitionID, int RoundNo, int EntryID, string Note)
        {
            List<SqlParameter> parameters = new List<SqlParameter>
            {
                new SqlParameter("CompetitionID", competitionID),
                new SqlParameter("RoundNo", RoundNo),
                new SqlParameter("EntryID", EntryID),
                new SqlParameter("comment", Note)
            };

            SQLcommands.ExecNonQuery("MergeCompetitionNote", parameters);
        }
        public static DataTable GetPlayByDates(int competitionID)
        {
            List<SqlParameter> parameters = new List<SqlParameter>
            {
                new SqlParameter("CompetitionID", competitionID),
            };

            return SQLcommands.ExecDataTable("GetPlayByDates", parameters);
        }

        #region "IDisposable support"
        private bool disposedValue; // To detect redundant calls

        // IDisposable
        protected virtual void Dispose(bool disposing)
        {
            if (!this.disposedValue)
            {
                if (disposing)
                {
                }
            }
            this.disposedValue = true;
        }

        // TODO: override Finalize() only if Dispose(ByVal disposing As Boolean) above has code to free unmanaged resources.
        // Protected Overrides Sub Finalize()
        // ' Do not change this code.  Put cleanup code in Dispose(ByVal disposing As Boolean) above.
        // Dispose(False)
        // MyBase.Finalize()
        // End Sub

        // This code added by Visual Basic to correctly implement the disposable pattern.
        public void Dispose()
        {
            // Do not change this code.  Put cleanup code in Dispose(disposing As Boolean) above.
            Dispose(true);
            GC.SuppressFinalize(this);
        }
        #endregion
    }
    public class ContentData : IDisposable
    {
        public string ContentName;
        public string ContentHTML;
        public DateTime dateTimeLodged;

        public ContentData(string contentName)
        {
            if (contentName == "**Create a new content**")
            {
                ContentName = "";
                ContentHTML = "";
                dateTimeLodged = HBSAcodeLibrary.Utilities.UKDateTimeNow();
            }
            else
            {
                DataTable content = SQLcommands.ExecDataTable("GetContentHTML",
                                                new List<SqlParameter> { new SqlParameter("ContentName", contentName) });
                ContentName = contentName;
                if (content.Rows.Count > 0)
                {
                    ContentHTML = (string)content.Rows[0].ItemArray[0];
                    dateTimeLodged = Convert.ToDateTime(content.Rows[0].ItemArray[1]);
                }
                else
                {
                    ContentHTML = "";
                    dateTimeLodged = HBSAcodeLibrary.Utilities.UKDateTimeNow();
                }
            }
        }
        public void Update()
        {
            List<SqlParameter> parameters = new List<SqlParameter>()
                {
                    new SqlParameter("ContentName", ContentName),
                    new SqlParameter("ContentHTML", ContentHTML)
                };

            SQLcommands.ExecNonQuery("UpdateContent", parameters);
        }
        public void Create()
        {
            List<SqlParameter> parameters = new List<SqlParameter>()
                {
                    new SqlParameter("ContentName", ContentName),
                    new SqlParameter("ContentHTML", ContentHTML)
                };

            SQLcommands.ExecNonQuery("CreateContent", parameters);
        }
        public void Delete()
        {
            List<SqlParameter> parameters = new List<SqlParameter>()
                {
                    new SqlParameter("ContentName", ContentName)
                };

            SQLcommands.ExecNonQuery("DeleteContent", parameters);
        }
        public static DataTable ContentNames()
        {
            return SQLcommands.ExecDataTable("GetContentNames");
        }
        #region IDisposable support

        private bool disposedValue; // To detect redundant calls

        // IDisposable
        protected virtual void Dispose(bool disposing)
        {
            if (!this.disposedValue)
            {
                if (disposing)
                {
                }
            }
            this.disposedValue = true;
        }

        // TODO: override Finalize() only if Dispose(ByVal disposing As Boolean) above has code to free unmanaged resources.
        // Protected Overrides Sub Finalize()
        // ' Do not change this code.  Put cleanup code in Dispose(ByVal disposing As Boolean) above.
        // Dispose(False)
        // MyBase.Finalize()
        // End Sub

        // This code added by Visual Basic to correctly implement the disposable pattern.
        public void Dispose()
        {
            // Do not change this code.  Put cleanup code in Dispose(disposing As Boolean) above.
            Dispose(true);
            GC.SuppressFinalize(this);
        }
        #endregion
    }
    public class Covid19Compliance : IDisposable
    {
        public int ClubID;
        public bool Check1;
        public bool Check2;
        public bool Check3;
        public bool Check4;
        public string Text3;
        public string Text4;
        public string Text5;
        public DateTime dtLodged;

        public Covid19Compliance()
        {
            ClubID = 0;
            Check1 = false;
            Check2 = false;
            Check3 = false;
            Check4 = false;
            Text3 = "";
            Text4 = "";
            Text5 = "";
            dtLodged = Utilities.UKDateTimeNow();
        }
        public Covid19Compliance(int clubID)
        {
            using (DataTable C19Report = SQLcommands.ExecDataTable("Covid19Compliance_Report",
                                                    new List<SqlParameter> { new SqlParameter("ClubID", clubID) }))
                if (C19Report.Rows.Count > 0)
                {
                    ClubID = clubID;

                    DataRow C19 = C19Report.Rows[0];
                    Check1 = (bool)C19["Check1"];
                    Check2 = (bool)C19["Check2"];
                    Check3 = (bool)C19["Check3"];
                    Check4 = (bool)C19["Check4"];
                    Text3 = (string)C19["Text3"];
                    Text4 = (string)C19["Text4"];
                    Text5 = (string)C19["Text5"];
                    dtLodged = (DateTime)C19["dtLodged"];
                }
            //else
            //{
            //    ClubID = clubID;

            //    Check1 = false;
            //    Check2 = false;
            //    Check3 = false;
            //    Check4 = false;
            //    Text3 = "";
            //    Text4 = "";
            //    Text5 = "";
            //    dtLodged = Utilities.UKDateTimeNow();
            //}

        }
        public void Merge()
        {
            SQLcommands.ExecNonQuery("Covid19Compliance_Merge",
                                                    new List<SqlParameter> { new SqlParameter("ClubID", ClubID),
                                                                             new SqlParameter("Check1", Check1),
                                                                             new SqlParameter("Check2", Check2),
                                                                             new SqlParameter("Check3", Check3),
                                                                             new SqlParameter("Check4", Check4),
                                                                             new SqlParameter("Text3", Text3),
                                                                             new SqlParameter("Text4", Text4),
                                                                             new SqlParameter("Text5", Text5),
                                                                           }
                                     );
        }
        public static DataTable Covid19Compliance_Report(int ClubID)
        {
            return SQLcommands.ExecDataTable("Covid19Compliance_Report",
                                                    new List<SqlParameter> { new SqlParameter("ClubID", ClubID) });
        }
        #region IDisposable implementation 
        private bool isDisposed = false;
        public void Dispose()
        {
            Dispose(true);
            GC.SuppressFinalize(this);
        }
        protected virtual void Dispose(bool disposing)
        {
            if (!isDisposed)
            {
                if (disposing)
                {
                    //TODO: dispose managed objects
                }
                //TODO: free unmanaged resources (unmanaged objects)
                //TODO: set large fields to null.
            }
            isDisposed = true;
        }
        #endregion
    }
    public class DebtsAndPayments : IDisposable
    {
        public DataTable moneySummary = new DataTable();
        public DebtsAndPayments(bool Owing = true, String paymentReason = "")
        {
            List<SqlParameter> parameters = new List<SqlParameter>()
            {
                new SqlParameter("Owing", Owing),
                new SqlParameter("PaymentReason", paymentReason)
            };
            moneySummary = SQLcommands.ExecDataTable("Money_SummaryReport", parameters);
        }
        public static DataTable PaymentsList(int clubID, string paymentReason = "")
        {
            List<SqlParameter> parameters = new List<SqlParameter>()
            {
                new SqlParameter("clubID", clubID),
                new SqlParameter("PaymentReason", paymentReason)
            };

            return SQLcommands.ExecDataTable("getPayments", parameters);
        }
        public static void UpdatePayment(int clubID, int fineID, string paymentMethod, string paymentReason,
                                         decimal amount, decimal paymentFee, string note, string transactionID,
                                         DateTime dateTimePaid, string paidBy, string user, int paymentID = 0)
        {
            List<SqlParameter> parameters = new List<SqlParameter>()
            {
                new SqlParameter("clubID", clubID),
                new SqlParameter("fineID", fineID),
                new SqlParameter("paymentMethod", paymentMethod),
                new SqlParameter("PaymentReason", paymentReason),
                new SqlParameter("amount", amount),
                new SqlParameter("paymentFee", paymentFee),
                new SqlParameter("note", note),
                new SqlParameter("transactionID", transactionID),
                new SqlParameter("dateTimePaid", dateTimePaid),
                new SqlParameter("paidBy", paidBy),
                new SqlParameter("user", user ?? "" )
            };

            if (paymentID >= 0)
            {
                parameters.Add(new SqlParameter("paymentID", paymentID));
            }

            SQLcommands.ExecNonQuery(paymentID < 0 ? "addPayment" : "updatePayment", parameters);
        }

        #region IDisposable implementation 
        private bool isDisposed = false;
        public void Dispose()
        {
            Dispose(true);
            GC.SuppressFinalize(this);
        }
        protected virtual void Dispose(bool disposing)
        {
            if (!isDisposed)
            {
                if (disposing)
                {
                    //TODO: dispose managed objects
                }
                //TODO: free unmanaged resources (unmanaged objects)
                //TODO: set large fields to null.
            }
            isDisposed = true;
        }
        #endregion
    }
    public class EmailTemplateData : IDisposable
    {
        public string eMailTemplateName;
        public string eMailTemplateHTML;
        public DateTime dateTimeLodged;

        public EmailTemplateData(string _eMailTemplateName)
        {
            if (eMailTemplateName == "**Create a new eMailTemplate**")
            {
                eMailTemplateName = "";
                eMailTemplateHTML = "";
                dateTimeLodged = HBSAcodeLibrary.Utilities.UKDateTimeNow();
            }
            else
            {
                DataTable eMailTemplate = SQLcommands.ExecDataTable("GeteMailTemplateHTML",
                                                new List<SqlParameter> { new SqlParameter("eMailTemplateName", _eMailTemplateName) });
                eMailTemplateName = _eMailTemplateName;
                if (eMailTemplate.Rows.Count > 0)
                {
                    eMailTemplateHTML = (string)eMailTemplate.Rows[0].ItemArray[0];
                    dateTimeLodged = Convert.ToDateTime(eMailTemplate.Rows[0].ItemArray[1]);
                }
                else
                {
                    eMailTemplateHTML = "";
                    dateTimeLodged = HBSAcodeLibrary.Utilities.UKDateTimeNow();
                }
            }
        }
        public void Create()
        {
            List<SqlParameter> parameters = new List<SqlParameter>()
                {
                    new SqlParameter("eMailTemplateName", eMailTemplateName),
                    new SqlParameter("eMailTemplateHTML", eMailTemplateHTML)
                };

            SQLcommands.ExecNonQuery("CreateEmailTemplate", parameters);
        }
        public void Update()
        {
            List<SqlParameter> parameters = new List<SqlParameter>()
                {
                    new SqlParameter("eMailTemplateName", eMailTemplateName),
                    new SqlParameter("eMailTemplateHTML", eMailTemplateHTML)
                };

            SQLcommands.ExecNonQuery("UpdateEmailTemplate", parameters);
        }
        public void Delete()
        {
            List<SqlParameter> parameters = new List<SqlParameter>()
                {
                    new SqlParameter("eMailTemplateName", eMailTemplateName)
                };

            SQLcommands.ExecNonQuery("DeleteEmailTemplate", parameters);
        }
        public static DataTable EmailTemplateNames()
        {
            return SQLcommands.ExecDataTable("GeteMailTemplateNames");
        }
        #region IDisposable support

        private bool disposedValue; // To detect redundant calls

        // IDisposable
        protected virtual void Dispose(bool disposing)
        {
            if (!this.disposedValue)
            {
                if (disposing)
                {
                }
            }
            this.disposedValue = true;
        }
        public void Dispose()
        {
            // Do not change this code.  Put cleanup code in Dispose(disposing As Boolean) above.
            Dispose(true);
            GC.SuppressFinalize(this);
        }
        #endregion
    }
    public class EntryFormData : IDisposable
    {
        public enum WIP
        {
            NotEntered,
            InProgress,
            Submitted,
            Fixed
        }

        public int ClubID;
        public string ClubName;
        public string Address1;
        public string Address2;
        public string PostCode;
        public string ContactName;
        public string ContactEMail;
        public string ContactTelNo;
        public string ContactMobNo;
        public int MatchTables;
        public WIP State;
        public decimal AmountPaid;
        public decimal ClubFee;
        public decimal TeamFees;
        public bool PrivacyAccepted;

        public DataTable Teams;
        public DataTable Players;
        public DataTable Payments;
        public EntryFormData(int ClubID)
        {
            GetEntryForm(ClubID);
        }
        public void GetEntryForm(int _ClubID)
        {
            List<SqlParameter> parameters = new List<SqlParameter>()
            {
                new SqlParameter("ClubID", _ClubID)
            };

            DataSet ds = SQLcommands.ExecDataSet("EntryForm_Details", parameters);

            if (ds.Tables[0].Rows.Count > 0)
            {
                DataRow ClubDetails = ds.Tables[0].Rows[0];
                ClubID = (int)ClubDetails["ClubID"];
                ClubName = (string)ClubDetails["Club Name"];
                Address1 = DBNull.Value == ClubDetails["Address1"] ? "" : (string)ClubDetails["Address1"];
                Address2 = DBNull.Value == ClubDetails["Address2"] ? "" : (string)ClubDetails["Address2"];
                PostCode = DBNull.Value == ClubDetails["PostCode"] ? "" : (string)ClubDetails["PostCode"];
                ContactName = (string)ClubDetails["ContactName"];
                ContactEMail = DBNull.Value == ClubDetails["ContactEMail"] ? "" : (string)ClubDetails["ContactEMail"];
                ContactTelNo = (string)ClubDetails["ContactTelNo"];
                ContactMobNo = (string)ClubDetails["ContactMobNo"];
                MatchTables = (int)ClubDetails["MatchTables"];
                State = (WIP)ClubDetails["WIP"];
                AmountPaid = Convert.ToDecimal(ClubDetails["AmountPaid"]);
                ClubFee = Convert.ToDecimal(ClubDetails["Fee"]);
                PrivacyAccepted = (bool)ClubDetails["PrivacyAccepted"];
            }

            Teams = ds.Tables[1];
            TeamFees = 0;
            foreach (DataRow Team in Teams.Rows)
                TeamFees += Convert.ToDecimal(Team["Fee"]);

            Players = ds.Tables[2];
            Payments = ds.Tables[3];

        }
        public int MergeClubData()
        {
            List<SqlParameter> parameters = new List<SqlParameter>()
            {
                new SqlParameter("ClubID", ClubID),
                new SqlParameter("ClubName", ClubName),  // Note that if this is zero length string it will delete the Club with the given ID
                new SqlParameter("Address1", Address1),
                new SqlParameter("Address2", Address2),
                new SqlParameter("PostCode", PostCode),
                new SqlParameter("ContactName", ContactName),
                new SqlParameter("ContactTelNo", ContactTelNo),
                new SqlParameter("ContactMobNo", ContactMobNo),
                new SqlParameter("MatchTables", MatchTables),
                new SqlParameter("PrivacyAccepted", PrivacyAccepted),
            };

            return (int)SQLcommands.ExecScalar("EntryForm_MergeClub", parameters);
        }
        public static DataTable GetClubs()
        {
            return SQLcommands.ExecDataTable("EntryForm_GetClubs");
        }
        public static void MergeTeam(int ClubID, int LeagueID, string Team, int Captain)
        {
            // TeamID if = -1 insert new team record for this entry
            // LeagueID if = -1 delete record
            List<SqlParameter> parameters = new List<SqlParameter>
            {
                new SqlParameter("ClubID", ClubID),
                new SqlParameter("LeagueID", LeagueID),
                new SqlParameter("Team", Team),
                new SqlParameter("Captain", Captain),
            };

            SQLcommands.ExecNonQuery("EntryForm_MergeTeam", parameters);
        }
        public void DeleteTeam(int _LeagueID, string _Team)
        {
            List<SqlParameter> parameters = new List<SqlParameter>
            {
                new SqlParameter("ClubID", ClubID),
                new SqlParameter("LeagueID", _LeagueID),
                new SqlParameter("Team", _Team)
            };

            SQLcommands.ExecNonQuery("EntryForm_DeleteTeam", parameters);

            // refresh the entry form with this deletion
            GetEntryForm(ClubID);
        }
        public static void MergePlayer(int PlayerID, int ClubID, int LeagueID, string Team, string Forename, string Inits, string Surname, int Handicap, string eMail, string TelNo, int Tagged, bool Over70, bool ReRegister)
        {
            List<SqlParameter> parameters = new List<SqlParameter>
            {
                    new SqlParameter("PlayerID", PlayerID),
                    new SqlParameter("ClubID", ClubID),
                    new SqlParameter("LeagueID", LeagueID),
                    new SqlParameter("Team", Team),
                    new SqlParameter("Forename", Forename),
                    new SqlParameter("Inits", Inits),
                    new SqlParameter("Surname", Surname),
                    new SqlParameter("Handicap", Handicap),
                    new SqlParameter("eMail", eMail),
                    new SqlParameter("TelNo", TelNo),
                    new SqlParameter("Tagged", Tagged),
                    new SqlParameter("Over70", Over70),
                    new SqlParameter("ReRegister", ReRegister),
            };

            SQLcommands.ExecNonQuery("EntryForm_MergePlayer", parameters);
        }
        public static void UpdateReRegister(int PlayerID, bool ReRegister)
        {
            List<SqlParameter> parameters = new List<SqlParameter>
            {
                    new SqlParameter("PlayerID", PlayerID),
                    new SqlParameter("ReRegister", ReRegister),
            };

            SQLcommands.ExecNonQuery("EntryForm_updateReRegisterPlayer", parameters);
        }
        public static void EntryForm_SetTeamCaptain(int PlayerID, bool Captain)
        {
            List<SqlParameter> parameters = new List<SqlParameter>
            {
                    new SqlParameter("PlayerID", PlayerID),
                    new SqlParameter("Captain", Captain),
            };

            SQLcommands.ExecNonQuery("EntryForm_SetTeamCaptain", parameters);
        }
        public static DataTable SimilarPlayers(int LeagueID, int ClubID, string Forename, string inits, string Surname)
        {
            List<SqlParameter> parameters = new List<SqlParameter>
            {
                    new SqlParameter("ClubID", ClubID),
                    new SqlParameter("LeagueID", LeagueID),
                    new SqlParameter("Forename", Forename),
                    new SqlParameter("Inits", inits),
                    new SqlParameter("Surname", Surname),
            };

            return SQLcommands.ExecDataTable("EntryForm_SimilarPlayers", parameters);
        }
        public static void TransferPlayer(int PlayerID, int ClubID, int LeagueID, string Team)
        {
            List<SqlParameter> parameters = new List<SqlParameter>
            {
                    new SqlParameter("PlayerID", PlayerID),
                    new SqlParameter("ClubID", ClubID),
                    new SqlParameter("LeagueID", LeagueID),
                    new SqlParameter("Team", Team),
            };

            SQLcommands.ExecNonQuery("EntryForm_TransferPlayer", parameters);
        }
        public void UpdateWIP(WIP State, string user)
        {
            List<SqlParameter> parameters = new List<SqlParameter>
            {
                    new SqlParameter("ClubID", ClubID),
                    new SqlParameter("WIP", State),
                    new SqlParameter("user", user ?? "None!"),
            };

            SQLcommands.ExecNonQuery("EntryForm_UpdateWIP", parameters);

        }
        public static void UpdateFeePaid(int _ClubID, decimal Amount, string user)
        {
            List<SqlParameter> parameters = new List<SqlParameter>
            {
                new SqlParameter("ClubID", _ClubID),
                new SqlParameter("Amount", Amount),
                new SqlParameter("user", user ?? "None!"),
            };

            SQLcommands.ExecNonQuery("EntryForm_UpdateFeePaid", parameters);
        }
        public decimal EntryFormFee()
        {
            List<SqlParameter> parameters = new List<SqlParameter>
            {
                    new SqlParameter("ClubID", ClubID),
            };

            return Convert.ToDecimal(SQLcommands.ExecScalar("EntryForm_ClubFee", parameters));
        }
        public static List<string> GetSuggestedPlayers(string prefixText, int count, int LeagueId)
        {
            List<string> suggestions = new List<string>();
            string[] TextWords = prefixText.Split(" ".ToCharArray());
            List<SqlParameter> parameters = new List<SqlParameter>
            {
                new SqlParameter("LeagueId", LeagueId),
                new SqlParameter("count", count),
                new SqlParameter("word1", TextWords[0])
            };
            if (TextWords.Count() > 1)
            {
                parameters.Add(new SqlParameter("word2", TextWords[1]));
                if (TextWords.Count() > 2)
                    parameters.Add(new SqlParameter("word3", TextWords[2]));
            }

            DataTable players = SQLcommands.ExecDataTable("EntryForm_SuggestPlayers", parameters);
            foreach (DataRow player in players.Rows)
            {
                suggestions.Add((string)player["Player"]);
            }

            return suggestions;
        }
        public static DataTable ClubsSummaryReport(WIP State) 
        {
            switch ((int)State)
            {
                case -3:
                    {
                        return SQLcommands.ExecDataTable("EntryForm_SummaryReport_ContactsByState");
                    }
                case -2:
                    {
                        return SQLcommands.ExecDataTable("EntryForm_SummaryReport_All");
                    }
                default:
                    {
                        return SQLcommands.ExecDataTable("EntryForm_SummaryReport",
                                                          new List<SqlParameter> { new SqlParameter("WIP", State) });
                    }
            }
        }
        public static DataTable TeamsSummaryReport(WIP State)
        {
            return SQLcommands.ExecDataTable("EntryForm_TeamsReport",
                                              new List<SqlParameter> { new SqlParameter("WIP", State) });
        }
        public static DataTable FullReport(string ReportType, int Parameter)
        {
            if (ReportType == "byClub")
            {
                return SQLcommands.ExecDataTable("EntryForm_FullReportForClub",
                                                  new List<SqlParameter> { new SqlParameter("ClubID", Parameter) });
            }
            else
            {
                return SQLcommands.ExecDataTable("EntryForm_FullReport",
                                                  new List<SqlParameter> { new SqlParameter("WIP", Parameter) });
            }
        }
        public static void InsertNewFee(string entity, int leagueID, decimal fee, string user)
        {
            SQLcommands.ExecNonQuery("EntryForm_InsertNewFee",
                                      new List<SqlParameter> { new SqlParameter("Entity", entity),
                                                               new SqlParameter("LeagueID", leagueID),
                                                               new SqlParameter("Fee", fee),
                                                               new SqlParameter("user", user ?? "Unknown")});
        }
        public static void UpdateFee(string entity, int leagueID, decimal fee, string user)
        {
            SQLcommands.ExecNonQuery("EntryForm_UpdateFee",
                                      new List<SqlParameter> { new SqlParameter("Entity", entity),
                                                               new SqlParameter("LeagueID", leagueID),
                                                               new SqlParameter("Fee", fee),
                                                               new SqlParameter("user", user ?? "Unknown")});
        }
        public static void DeleteFee(string entity, int leagueID, string user)
        {
            SQLcommands.ExecNonQuery("EntryForm_DeleteFee",
                                      new List<SqlParameter> { new SqlParameter("Entity", entity),
                                                               new SqlParameter("LeagueID", leagueID),
                                                               new SqlParameter("user", user ?? "Unknown")});
        }
        public static DataTable GetFees()
        {
            return SQLcommands.ExecDataTable("EntryForm_GetFees");
        }
        public static DataTable ApplyEntryForms(string user)
        {
            return SQLcommands.ExecDataTable("ApplyEntryForms",
                                             new List<SqlParameter> { new SqlParameter("user", user ?? "Unknown") });
        }
        public static void SetupEntryForms()
        {
            SQLcommands.ExecNonQuery("EntryForm_CreateTables");
        }
        public static DataTable ClubsWithoutLogin()
        {
            return SQLcommands.ExecDataTable("ClubsWithoutClubLogin");
        }
        public static DataTable EntryFormsNewPlayers()
        {
            return SQLcommands.ExecDataTable("EntryFormsNewPlayers");
        }

        #region IDisposable support

        private bool disposedValue = false;        // To detect redundant calls

        // IDisposable
        protected virtual void Dispose(bool disposing)
        {
            if (!this.disposedValue)
            {
                if (disposing)
                {
                }
            }
            this.disposedValue = true;
        }
        // This code added by Visual Basic to correctly implement the disposable pattern.
        public void Dispose()
        {
            // Do not change this code.  Put cleanup code in Dispose(ByVal disposing As Boolean) above.
            Dispose(true);
            GC.SuppressFinalize(this);
        }
        #endregion
    }
    public class Fines : IDisposable
    {
        public int FineID;
        public DateTime DateImposed;
        public int ClubID;
        public string Offence;
        public string Comment;
        public decimal Amount;
        public decimal AmountPaid;
        public string ClubName;
        public DataTable Payments;

        public Fines(int fineID)
        {
            DataSet fineDetail = SQLcommands.ExecDataSet("Fine_Detail",
                                                         new List<SqlParameter> { new SqlParameter("FineID", fineID) });

            if (fineDetail.Tables.Count > 0 && fineDetail.Tables[0].Rows.Count > 0)
            {
                DataRow withBlock = fineDetail.Tables[0].Rows[0];
                FineID = (int)withBlock["ID"];
                DateImposed = Convert.ToDateTime(withBlock["dtlodged"]);
                ClubID = (int)withBlock["ClubID"];
                Offence = (string)withBlock["Offence"];
                Comment = (string)withBlock["Comment"];
                Amount = Convert.ToDecimal(withBlock["Fine"]);
                AmountPaid = Convert.ToDecimal(withBlock["AmountPaid"]);
                ClubName = (string)withBlock["Club Name"];

                Payments = fineDetail.Tables[1];
            }
        }
        public static DataTable Summary(bool Owing, int ClubID = 0, bool forMobile = false)
        {
            return SQLcommands.ExecDataTable("Fines_Summary",
                                             new List<SqlParameter> {new SqlParameter("Owing", Owing),
                                                                     new SqlParameter("ClubID", ClubID),
                                                                     new SqlParameter("forMobile", forMobile)});
        }
        public static DataTable PaymentsList(int ClubID, int FineID)
        {
            return SQLcommands.ExecDataTable("Fines_GetPayments",
                                             new List<SqlParameter> {new SqlParameter("FineID", FineID),
                                                                     new SqlParameter("ClubID", ClubID) });
        }
        public static string ImposeFine(int ClubID, string Offence, string Comment, decimal Amount)
        {
            return (string)SQLcommands.ExecScalar("Fines_ImposeFine",
                                             new List<SqlParameter> {new SqlParameter("ClubID", ClubID),
                                                                     new SqlParameter("Offence", Offence),
                                                                     new SqlParameter("Comment", Comment),
                                                                     new SqlParameter("Amount", Amount)
                                                                     });
        }
        public static void RescindFine(int FineID, bool Override = false)
        {
            SQLcommands.ExecNonQuery("Fines_RescindFine",
                                      new List<SqlParameter> {new SqlParameter("FineID", FineID),
                                                              new SqlParameter("Override", Override) });
        }

        #region IDisposable support
        private bool disposedValue; // To detect redundant calls

        // IDisposable
        protected virtual void Dispose(bool disposing)
        {
            if (!disposedValue)
            {
                if (disposing)
                {
                }
            }
            disposedValue = true;
        }

        // TODO: override Finalize() only if Dispose(disposing As Boolean) above has code to free unmanaged resources.
        // Protected Overrides Sub Finalize()
        // ' Do not change this code.  Put cleanup code in Dispose(disposing As Boolean) above.
        // Dispose(False)
        // MyBase.Finalize()
        // End Sub

        // This code added by Visual Basic to correctly implement the disposable pattern.
        public void Dispose()
        {
            // Do not change this code.  Put cleanup code in Dispose(disposing As Boolean) above.
            Dispose(true);
        }
        #endregion
    }
    public class FixtureGrid : IDisposable
    {
        public DataTable FixtureMatrix = new DataTable();
        public int NoOfTeams;
        public int NoWeeks;
        public int NoMatches;
        public FixtureGrid()
        {
        }
        public FixtureGrid(int SectionID)
        {
            GetFixtureGrid(SectionID);
        }
        public void GetFixtureGrid(int SectionID)
        {
            GetFixtureTable(SectionID, "GetFixtureGrid");
        }
        public void GetFixtureMatrix(int SectionID)
        {
            GetFixtureTable(SectionID, "GetFixtureMatrix");
        }
        public void GetFixtureTable(int SectionID, string StoredProcedure)
        {
            FixtureMatrix = SQLcommands.ExecDataTable(StoredProcedure,
                                                      new List<SqlParameter> { new SqlParameter("SectionID", SectionID) });
            NoOfTeams = Convert.ToInt32(FixtureMatrix.Rows[0]["SectionSize"]);
            NoWeeks = FixtureMatrix.Rows.Count;
            for (int ix = 3, loopTo = FixtureMatrix.Rows[0].ItemArray.Length - 1; ix <= loopTo; ix += 2)
                if (DBNull.Value != FixtureMatrix.Rows[0][ix])
                    NoMatches += 1;
        }
        public void Merge(int SectionID)
        {
            // given a fixture grid table put it in the database

            using (SqlConnection cn = new SqlConnection(SQLcommands.ConnString()))
            {
                cn.Open();

                // delete any existing grid for this section
                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.Connection = cn;
                    cmd.CommandType = CommandType.Text;
                    cmd.CommandText = "delete FixtureGrids where SectionID = " + Convert.ToString(SectionID);
                    cmd.ExecuteNonQuery();
                }

                // bulk insert the new grid
                using (SqlBulkCopy bc = new SqlBulkCopy(cn))
                {
                    bc.DestinationTableName = "dbo.FixtureGrids";
                    bc.WriteToServer(FixtureMatrix);
                }

                cn.Close();
            }
        }

        public static void UpdateRows(string type, int SectionID, int Week1, int Week2, bool Unlocked)
        {
            SQLcommands.ExecNonQuery("FixtureGrid_" + type + "_Week",
                                     new List<SqlParameter> { new SqlParameter("SectionID", SectionID),
                                                              new SqlParameter("Week1", Week1),
                                                              new SqlParameter("Week2", Week2),
                                                              new SqlParameter("Unlocked", Unlocked) });
        }

        #region IDisposable support
        private bool disposedValue = false;        // To detect redundant calls

        // IDisposable
        protected virtual void Dispose(bool disposing)
        {
            if (!disposedValue)
            {
                if (disposing)
                {
                    // TODO: free other state (managed objects).
                }

                // TODO: free your own state (unmanaged objects).
                // TODO: set large fields to null.
            }

            disposedValue = true;
        }
        // This code added by Visual Basic to correctly implement the disposable pattern.
        public void Dispose()
        {
            // Do not change this code.  Put cleanup code in Dispose(ByVal disposing As Boolean) above.
            Dispose(true);
            GC.SuppressFinalize(this);
        }
        #endregion
    }
    public class FixturesData : IDisposable
    {
        public DataTable CurfewDates;
        public DataTable Dates;
        public int NoOfFixtures;
        public DateTime StartOfSeason;
        public DateTime EndOfSeason;
        public FixturesData()
        {
            // No ID, does nothing, just instatiate the class, formats and fills the season dates the tables
            GetFixtureDates(0);
        }
        public FixturesData(int SectionID)
        {
            GetFixtureDates(SectionID);
        }
        public void GetFixtureDates(int SectionID)
        {
            using (DataSet fixtureDates = SQLcommands.ExecDataSet("GetFixtureDatesForSection",
                                                                  new List<SqlParameter> { new SqlParameter("SectionID", SectionID) }))
            {
                CurfewDates = fixtureDates.Tables[0];
                Dates = fixtureDates.Tables[1];
                NoOfFixtures = fixtureDates.Tables[1].Rows.Count;
            }

            using (DataTable seasonDates = SQLcommands.ExecDataTable("GetSeasonDates"))
            {
                StartOfSeason = Convert.ToDateTime(seasonDates.Rows[0]["StartOfSeason"]);
                EndOfSeason = Convert.ToDateTime(seasonDates.Rows[0]["EndOfSeason"]);
            }
        }
        public string Merge(int SectionID)
        {
            return (string)SQLcommands.ExecScalar("MergeFixtureDates",
                                                  new List<SqlParameter> { new SqlParameter("SectionID", SectionID),
                                                                           new SqlParameter("StartDate", CurfewDates.Rows[0]["StartDate"]),
                                                                           new SqlParameter("CurfewStart", CurfewDates.Rows[0]["CurfewStart"]),
                                                                           new SqlParameter("CurfewEnd", CurfewDates.Rows[0]["CurfewEnd"]),
                                                                           new SqlParameter("NoOfFixtures", NoOfFixtures) });
        }
        public static int DefaultNoOfFixtures(int SectionID)
        {
            return (int)SQLcommands.ExecScalar("DefaultNoOfFixtures",
                                                new List<SqlParameter> { new SqlParameter("SectionID", SectionID) });
        }
        public static DataSet FixtureList(int SectionID, string MatchDate, string TeamName)
        {
            List<SqlParameter> parameters = new List<SqlParameter>();
            string commandText;

            if (!TeamName.StartsWith("All"))
                parameters.Add(new SqlParameter("TeamName", TeamName));

            if (!TeamName.StartsWith("All") && MatchDate.StartsWith("All"))
            {
                commandText = "FixturesByTeam";
                parameters.Add(new SqlParameter("LeagueSectionID", SectionID));
            }
            else if (SectionID > 99)
            {
                commandText = "FixturesByLeague";
                parameters.Add(new SqlParameter("LeagueID", SectionID - 100));
                if (!MatchDate.StartsWith("All"))
                    parameters.Add(new SqlParameter("FixtureDate", Convert.ToDateTime(MatchDate)));
            }
            else
            {
                commandText = "FixturesBySection";
                parameters.Add(new SqlParameter("SectionID", SectionID));
                if (!MatchDate.StartsWith("All"))
                    parameters.Add(new SqlParameter("FixtureDate", Convert.ToDateTime(MatchDate)));
            }

            return SQLcommands.ExecDataSet(commandText, parameters);
        }
        public static DataSet GetFixtures(int sectionID)
        {
            return SQLcommands.ExecDataSet("GetFixtures",
                                            new List<SqlParameter> { new SqlParameter("SectionID", sectionID) });
        }
        public static DataTable GetFixturesSideBySide(int sectionID)
        {
            return SQLcommands.ExecDataTable("GetFixturesSideBySide",
                                              new List<SqlParameter> { new SqlParameter("SectionID", sectionID) });
        }
        public static DataTable GetFixtureDatesForTeam(int TeamID)
        {
            return SQLcommands.ExecDataTable("GetFixtureDates",
                                              new List<SqlParameter> { new SqlParameter("TeamID", TeamID) });
        }
        public static DataSet GetFixtureDatesForLeague(int leagueID)
        {
            return SQLcommands.ExecDataSet("GetFixtureDatesForLeague", new List<SqlParameter> { new SqlParameter("LeagueID", leagueID) });
        }
        public static void EndTheSeason()
        {
            SQLcommands.ExecNonQuery("EndOfSeason");
        }
        public static void StartTheSeason()
        {
            SQLcommands.ExecNonQuery("StartOfSeason");
        }

        #region IDisposable support
        private bool disposedValue = false;        // To detect redundant calls

        // IDisposable
        protected virtual void Dispose(bool disposing)
        {
            if (!disposedValue)
            {
                if (disposing)
                {
                    // TODO: free other state (managed objects).
                }

                // TODO: free your own state (unmanaged objects).
                // TODO: set large fields to null.
            }

            disposedValue = true;
        }
        // This code added by Visual Basic to correctly implement the disposable pattern.
        public void Dispose()
        {
            // Do not change this code.  Put cleanup code in Dispose(ByVal disposing As Boolean) above.
            Dispose(true);
            GC.SuppressFinalize(this);
        }
        #endregion
    }
    public class HBSA_Configuration : IDisposable
    {
        public DataTable Config;
        public HBSA_Configuration()
        {
            Config = SQLcommands.ExecDataTable("GetConfiguration");
        }
        public string Value(string Key)
        {
            foreach (DataRow cfgRow in Config.Rows)
            {
                if (((string)cfgRow["Key"]).ToLower() == Key.ToLower())
                    return (string)cfgRow["value"];
            }

            return "";
        }
        public static void Update(string key, string value)
        {
            List<SqlParameter> parameters = new List<SqlParameter>()
            {
                new SqlParameter("key", key),
                new SqlParameter("value", value)
            };

            SQLcommands.ExecNonQuery("UpdateConfig", parameters);
        }
        public static void Insert(string key, string value)
        {
            List<SqlParameter> parameters = new List<SqlParameter>()
            {
                new SqlParameter("key", key),
                new SqlParameter("value", value),
            };

            SQLcommands.ExecNonQuery("InsertNewConfigurationKey", parameters);
        }
        public static void Delete(string key)
        {
            List<SqlParameter> parameters = new List<SqlParameter>()
            {
                new SqlParameter("key", key)
            };

            SQLcommands.ExecNonQuery("DeleteConfig", parameters);
        }
        public static bool CloseSeason()
        {
            return ConvertConfigurationValueToBoolean("CloseSeason");
        }
        public static bool AllowAGMvote()
        {
            return ConvertConfigurationValueToBoolean("AllowAGMvote");
        }
        public static bool AllowCompetitionsEntryForms()
        {
            return ConvertConfigurationValueToBoolean("AllowCompetitionsEntryForms");
        }
        public static void AllowCompetitionsEntryForms(bool OpenClosed)
        {
            if (OpenClosed)
            {
                SQLcommands.ExecNonQuery("AllowCompetitionsEntryForms");
            }
            else
                HBSA_Configuration.Update("AllowCompetitionsEntryForms", "0");
        }
        public static bool AllowLeaguesEntryForms()
        {
            return ConvertConfigurationValueToBoolean("AllowLeaguesEntryForms");
        }
        public static void AllowLeaguesEntryForms(bool OpenClosed)
        {
            if (OpenClosed)
            {
                SQLcommands.ExecNonQuery("AllowLeaguesEntryForms");
            }
            else
                HBSA_Configuration.Update("AllowLeaguesEntryForms", "0");
        }
        internal static bool ConvertConfigurationValueToBoolean(string key)
        {
            using (HBSA_Configuration cfg = new HBSA_Configuration())
            {
                string value = cfg.Value(key);

                if (Int32.TryParse(value, out int iValue))
                {
                    if (value == "1") return true;
                    else return false;
                }
                else
                {
                    if (value.ToLower() == "true") return true;
                    else return false;
                }
            }
        }
        #region "IDisposable"
        private bool disposedValue = false;        // To detect redundant calls

        // IDisposable
        protected virtual void Dispose(bool disposing)
        {
            if (!this.disposedValue)
            {
                if (disposing)
                {
                }
            }
            this.disposedValue = true;
        }

        // This code added by Visual Basic to correctly implement the disposable pattern.
        public void Dispose()
        {
            // Do not change this code.  Put cleanup code in Dispose(ByVal disposing As Boolean) above.
            Dispose(true);
            GC.SuppressFinalize(this);
        }
        #endregion
    }
    public class HomeContent : IDisposable
    {
        public int ID;
        public DateTime dateTimeLodged;
        public string title;
        public string articleHTML;
        public HomeContent(int id)
        {
            if (id < 1)
            {
                ID = 0;
                dateTimeLodged = HBSAcodeLibrary.Utilities.UKDateTimeNow();
                title = "";
                articleHTML = "";
            }
            else
            {
                DataRow dr = SQLcommands.ExecDataTable("HomePageArticle",
                                                        new List<SqlParameter> { new SqlParameter("ID", id) }).Rows[0];
                if (dr != null)
                {
                    ID = (int)dr["ID"];
                    dateTimeLodged = Convert.ToDateTime(dr["dtLodged"]);
                    title = (string)dr["Title"];
                    articleHTML = (string)dr["ArticleHTML"];
                }
            }
        }
        public void Merge()  // Note that if ID is 0 it will insert, and -ve will delete 
        {
            SQLcommands.ExecNonQuery("HomePageMerge",
                                      new List<SqlParameter> { new SqlParameter("ID", ID),
                                                               new SqlParameter("Title", title),
                                                               new SqlParameter("ArticleHTML", articleHTML)});
        }
        public static void DeleteALL()
        {
            SQLcommands.ExecNonQuery("HomePageDeleteALL");
        }
        public static DataTable HomePageArticles()
        {
            return SQLcommands.ExecDataTable("HomePageArticles");
        }

        #region IDisposable support
        private bool disposedValue; // To detect redundant calls

        // IDisposable
        protected virtual void Dispose(bool disposing)
        {
            if (!disposedValue)
            {
                if (disposing)
                {
                    // TODO: dispose managed state (managed objects).
                }

                // TODO: free unmanaged resources (unmanaged objects) and override Finalize() below.
                // TODO: set large fields to null.
            }

            disposedValue = true;
        }

        // TODO: override Finalize() only if Dispose(disposing As Boolean) above has code to free unmanaged resources.
        // Protected Overrides Sub Finalize()
        // ' Do not change this code.  Put cleanup code in Dispose(disposing As Boolean) above.
        // Dispose(False)
        // MyBase.Finalize()
        // End Sub

        // This code added by Visual Basic to correctly implement the disposable pattern.
        public void Dispose()
        {
            // Do not change this code.  Put cleanup code in Dispose(disposing As Boolean) above.
            Dispose(true);
            // TODO: uncomment the following line if Finalize() is overridden above.
            // GC.SuppressFinalize(Me)
        }
        #endregion
    }
    public class InfoFiles : IDisposable
    {
        public string HTML;

        public InfoFiles(string FilePath)
        {
            using (System.IO.StreamReader InfoFile = new System.IO.StreamReader(FilePath, System.Text.Encoding.Default, true))
            {
                HTML = InfoFile.ReadToEnd().Replace("�", "");  // Filtere out MS Word end line character

                // Filter out html tags
                int ix1 = HTML.IndexOf("<html");
                if (ix1 >= 0)
                {
                    int ix2 = HTML.IndexOf(">", ix1);
                    if (ix2 > ix1)
                    {
                        HTML = HTML.Substring(0, ix1) + HTML.Substring(ix2 + 1, HTML.Length - ix2 - 1);
                        ix1 = HTML.LastIndexOf("</html");
                        if (ix1 >= 0)
                        {
                            ix2 = HTML.LastIndexOf(">");
                            if (ix2 > ix1)
                                HTML = HTML.Substring(0, ix1) + HTML.Substring(ix2 + 1, HTML.Length - ix2 - 1);
                        }
                    }
                }
            }
        }
        #region  IDisposable support
        private bool disposedValue; // To detect redundant calls

        // IDisposable
        protected virtual void Dispose(bool disposing)
        {
            if (!this.disposedValue)
            {
                if (disposing)
                {
                }
            }
            this.disposedValue = true;
        }

        // TODO: override Finalize() only if Dispose(ByVal disposing As Boolean) above has code to free unmanaged resources.
        // Protected Overrides Sub Finalize()
        // ' Do not change this code.  Put cleanup code in Dispose(ByVal disposing As Boolean) above.
        // Dispose(False)
        // MyBase.Finalize()
        // End Sub

        // This code added by Visual Basic to correctly implement the disposable pattern.
        public void Dispose()
        {
            // Do not change this code.  Put cleanup code in Dispose(disposing As Boolean) above.
            Dispose(true);
            GC.SuppressFinalize(this);
        }
        #endregion
    }
    public class JuniorsCompetitions : IDisposable
    {
        public DataSet Results;
        public DataSet Tables;

        public JuniorsCompetitions()
        {
            Tables = SQLcommands.ExecDataSet("JuniorsTables");
            Results = SQLcommands.ExecDataSet("JuniorsResults");
        }
        public static void PromoteToKO()
        {
            SQLcommands.ExecNonQuery("JuniorsPromoteToKO");
        }
        public static void SetupJuniors(int NoOfLeagues)
        {
            List<SqlParameter> parameters = new List<SqlParameter>()
            {
                new SqlParameter("NoOfLeagues", NoOfLeagues)
            };

            SQLcommands.ExecNonQuery("JuniorsSetUpLeagues", parameters);
        }
        public static bool ResultsExist()
        {
            return System.Convert.ToBoolean(SQLcommands.ExecScalar("JuniorsResultsExist"));
        }
        public static DataTable JuniorsResultsForAdmin()
        {
            return SQLcommands.ExecDataTable("JuniorsResultsForAdmin");
        }
        public static void UpdateJuniorResult (int resultID, int[] frameScores) 
        {
            SQLcommands.ExecNonQuery("JuniorsUpdateResult",
                                        new List<SqlParameter>
                                        {   new SqlParameter("ID", resultID),
                                            new SqlParameter("HomeFrame1", frameScores[0]),
                                            new SqlParameter("AwayFrame1", frameScores[1]),
                                            new SqlParameter("HomeFrame2", frameScores[2]),
                                            new SqlParameter("AwayFrame2", frameScores[3]),
                                            new SqlParameter("HomeFrame3", frameScores[4]),
                                            new SqlParameter("AwayFrame3", frameScores[5]),
                                        });
        }
        #region "IDisposable support"
        private bool disposedValue; // To detect redundant calls

        // IDisposable
        protected virtual void Dispose(bool disposing)
        {
            if (!disposedValue)
            {
                if (disposing)
                {
                }
            }
            disposedValue = true;
        }

        // TODO: override Finalize() only if Dispose(disposing As Boolean) above has code to free unmanaged resources.
        // Protected Overrides Sub Finalize()
        // ' Do not change this code.  Put cleanup code in Dispose(disposing As Boolean) above.
        // Dispose(False)
        // MyBase.Finalize()
        // End Sub

        // This code added by Visual Basic to correctly implement the disposable pattern.
        public void Dispose()
        {
            // Do not change this code.  Put cleanup code in Dispose(disposing As Boolean) above.
            Dispose(true);
        }
        #endregion
    }
    public class LeagueData : IDisposable
    {
        public int ID;
        public string LeagueName;
        public DataTable Sections;
        public DataTable Teams;
        public DataTable Players;
        public int MaxHandicap;
        public int MinHandicap;
        public LeagueData(int LeagueID)
        {
            GetLeagueData(LeagueID);
        }
        public void GetLeagueData(int LeagueID)
        {
            DataSet ds = SQLcommands.ExecDataSet("LeagueDetails", new List<SqlParameter> { new SqlParameter("ID", LeagueID) });

            if (ds.Tables[0].Rows.Count > 0)
            {
                ID = (int)ds.Tables[0].Rows[0]["ID"];
                LeagueName = (string)ds.Tables[0].Rows[0]["League Name"];
                MaxHandicap = (int)ds.Tables[0].Rows[0]["MaxHandicap"];
                MinHandicap = (int)ds.Tables[0].Rows[0]["MinHandicap"];
            }
            Sections = ds.Tables[1];
            Teams = ds.Tables[2];
            Players = ds.Tables[3];
        }
        public string Merge()
        {
            return (string)SQLcommands.ExecScalar("MergeLeague",
                                                   new List<SqlParameter> { new SqlParameter("LeagueID", ID),
                                                                            new SqlParameter("LeagueName", LeagueName),
                                                                            new SqlParameter("MaxHandicap", MaxHandicap),
                                                                            new SqlParameter("MinHandicap", MinHandicap)});
        }
        public static DataTable AllLeagues()
        {
            return SQLcommands.ExecDataTable("GetAllLeagues");
        }
        public static DataTable GetSections(int LeagueID)
        {
            return SQLcommands.ExecDataTable("GetSections",
                                               new List<SqlParameter> { new SqlParameter("LeagueID", LeagueID) });
        }
        public static DataTable GetLeagues()
        {
            return SQLcommands.ExecDataTable("GetLeagues");
        }
        public static DataTable GetLeaguesWithHandicapLimits()
        {
            return SQLcommands.ExecDataTable("GetLeaguesWithHandicapLimits");
        }
        public static DataTable LeagueTable(int SectionID)
        {
            return SQLcommands.ExecDataTable("LeagueTable",
                                              new List<SqlParameter> { new SqlParameter("SectionID", SectionID) });
        }
        public static DataTable GetLast6Matches(int LeagueID, int SectionID)
        {
            return SQLcommands.ExecDataTable("LastSixMatches",
                                              new List<SqlParameter> { new SqlParameter("LeagueID", LeagueID),
                                                                       new SqlParameter("SectionID", SectionID) });
        }
        public static void AssignFixtureGrids(int LeagueID)
        {
            SQLcommands.ExecNonQuery("AssignFixtureGrids",
                                     new List<SqlParameter> { new SqlParameter("LeagueID", LeagueID) });
        }

        #region IDisposable support
        private bool disposedValue = false;        // To detect redundant calls

        // IDisposable
        protected virtual void Dispose(bool disposing)
        {
            if (!disposedValue)
            {
                if (disposing)
                {
                    // TODO: free other state (managed objects).
                }

                // TODO: free your own state (unmanaged objects).
                // TODO: set large fields to null.
            }

            disposedValue = true;
        }
        // This code added by Visual Basic to correctly implement the disposable pattern.
        public void Dispose()
        {
            // Do not change this code.  Put cleanup code in Dispose(ByVal disposing As Boolean) above.
            Dispose(true);
            GC.SuppressFinalize(this);
        }
        #endregion
    }
    public class MatchResult : IDisposable
    {
        public int MatchResultID;
        public DataTable Match; // 1 row of ID, Match Date, League Name, Section Name, Home, H_Pts, A_Pts, Away, Fixture Date
        public DataTable Frames; // 3 or 4 rows of FN, Home H'Cap, HomeScore, HomePlayer, AwayPlayer, AwayScore, Away H'cap
        public DataTable HomeBreaksTable; // rows of Player, ID, MatchResultID, PlayerID, Break
        public DataTable AwayBreaksTable; // rows of Player, ID, MatchResultID, PlayerID, Break
        public MatchResult()
        {
            // set up empty result card.
            // This will format table columns
            GetResultCard(0, 0, new DateTime(2000, 1, 1));
        }
        public MatchResult(int HomeTeamID, int AwayTeamID, DateTime FixtureDate)
        {
            GetResultCard(HomeTeamID, AwayTeamID, FixtureDate);
        }
        private void GetResultCard(int HomeTeamID, int AwayTeamID, DateTime FixtureDate)
        {
            DataSet matchResult = SQLcommands.ExecDataSet("checkForResultsCard",
                                                           new List<SqlParameter> { new SqlParameter("HomeTeamID", HomeTeamID),
                                                                                    new SqlParameter("AwayTeamID", AwayTeamID),
                                                                                    new SqlParameter("FixtureDate", FixtureDate)});
            Match = matchResult.Tables[0];
            Frames = matchResult.Tables[1];
            HomeBreaksTable = matchResult.Tables[2];
            AwayBreaksTable = matchResult.Tables[3];
            if (matchResult.Tables[0].Rows.Count > 0)
                MatchResultID = (int)Match.Rows[0]["ID"];
            else
                MatchResultID = -1;
        }
        public void Recover(int HomeTeamID, int AwayTeamID, DateTime FixtureDate)
        {
            // given the home & away teams, recover the most recent match result and populate the object
            SQLcommands.ExecDataSet("RecoverMatchResult",
                                     new List<SqlParameter> { new SqlParameter("HomeTeamID", HomeTeamID),
                                                              new SqlParameter("AwayTeamID", AwayTeamID) });
            GetResultCard(HomeTeamID, AwayTeamID, FixtureDate);
        }
        public static DataTable BreaksForMatch(int HomeTeamID, int AwayTeamID)
        {
            return SQLcommands.ExecDataTable("breaksForMatch",
                                              new List<SqlParameter> { new SqlParameter("HomeTeamID", HomeTeamID),
                                                                       new SqlParameter("AwayTeamID", AwayTeamID) });
        }
        public static bool DeletedExists(int HomeTeamID, int AwayTeamID)
        {
            // given the home & away teams, recover the most recent match result and populate the object
            return Convert.ToBoolean(SQLcommands.ExecScalar("DeletedMatchResult",
                                                             new List<SqlParameter> { new SqlParameter("HomeTeamID", HomeTeamID),
                                                                                      new SqlParameter("AwayTeamID", AwayTeamID) }));
        }
        public static void Delete(int HomeTeamID, int AwayTeamID, string UserID)
        {
            SQLcommands.ExecNonQuery("deleteMatchResult",
                                      new List<SqlParameter> { new SqlParameter("HomeTeamID", HomeTeamID),
                                                               new SqlParameter("AwayTeamID", AwayTeamID),
                                                               new SqlParameter("UserID", UserID) });
        }
        public static int InsertResultCard(DateTime MatchDate, int HomeTeamID, int AwayTeamID, string HomePlayer1, int HomeScore1, string AwayPlayer1, int AwayScore1, string HomePlayer2, int HomeScore2, string AwayPlayer2, int AwayScore2, string HomePlayer3, int HomeScore3, string AwayPlayer3, int AwayScore3, string HomePlayer4, int HomeScore4, string AwayPlayer4, int AwayScore4, int HomeHandicap1, int HomeHandicap2, int HomeHandicap3, int HomeHandicap4, int AwayHandicap1, int AwayHandicap2, int AwayHandicap3, int AwayHandicap4, string UserID)
        {
            List<SqlParameter> parameters = new List<SqlParameter>
            {
               new SqlParameter("MatchDate", MatchDate),
                new SqlParameter("HomeTeamID", HomeTeamID),
                new SqlParameter("AwayTeamID", AwayTeamID),
                new SqlParameter("HomePlayer1", HomePlayer1),
                new SqlParameter("HomeScore1", HomeScore1),
                new SqlParameter("AwayPlayer1", AwayPlayer1),
                new SqlParameter("AwayScore1", AwayScore1),
                new SqlParameter("HomePlayer2", HomePlayer2),
                new SqlParameter("HomeScore2", HomeScore2),
                new SqlParameter("AwayPlayer2", AwayPlayer2),
                new SqlParameter("AwayScore2", AwayScore2),
                new SqlParameter("HomePlayer3", HomePlayer3),
                new SqlParameter("HomeScore3", HomeScore3),
                new SqlParameter("AwayPlayer3", AwayPlayer3),
                new SqlParameter("AwayScore3", AwayScore3),
                new SqlParameter("HomePlayer4", HomePlayer4),
                new SqlParameter("HomeScore4", HomeScore4),
                new SqlParameter("AwayPlayer4", AwayPlayer4),
                new SqlParameter("AwayScore4", AwayScore4),
                new SqlParameter("HomeHandicap1", HomeHandicap1),
                new SqlParameter("HomeHandicap2", HomeHandicap2),
                new SqlParameter("HomeHandicap3", HomeHandicap3),
                new SqlParameter("HomeHandicap4", HomeHandicap4),
                new SqlParameter("AwayHandicap1", AwayHandicap1),
                new SqlParameter("AwayHandicap2", AwayHandicap2),
                new SqlParameter("AwayHandicap3", AwayHandicap3),
                new SqlParameter("AwayHandicap4", AwayHandicap4),
                new SqlParameter("UserID", UserID),
            };

            return (int)SQLcommands.ExecScalar("insertMatchResult", parameters);
        }
        public static void InsertMatchBreak(int MatchResultID, int PlayerID, int Break, string UserID)
        {
            SQLcommands.ExecNonQuery("insertMatchBreak",
                                      new List<SqlParameter> { new SqlParameter("MatchResultID", MatchResultID),
                                                               new SqlParameter("PlayerID", PlayerID),
                                                               new SqlParameter("Break", Break),
                                                               new SqlParameter("UserID", UserID)});
        }
        public static DataTable MissingResults()
        {
            return SQLcommands.ExecDataTable("MissingResults");
        }
        public static DataSet ListResults(int sectionID, string matchDate = null, int teamID = 0)
        {
            List<SqlParameter> parameters = new List<SqlParameter> { };

            if (sectionID < 0)
            {
                sectionID = 0;
                parameters.Add(new SqlParameter("SectionID", sectionID));
                parameters.Add(new SqlParameter("NoShows", true));
            }
            else
            {
                parameters.Add(new SqlParameter("SectionID", sectionID));
                if (matchDate != null)
                    parameters.Add(new SqlParameter("MatchDate", matchDate));
                if (teamID != 0)
                    parameters.Add(new SqlParameter("TeamID", teamID));
            }
            return SQLcommands.ExecDataSet("ListResults", parameters);
        }
        public static DataSet ResultCard(int matchResultID)
        {
            return SQLcommands.ExecDataSet("ResultsCard",
                                            new List<SqlParameter> { new SqlParameter("MatchResultID", matchResultID) });
        }
        public static DataSet TeamResultsSheet(int teamID)
        {
            return SQLcommands.ExecDataSet("TeamResultsSheet", new List<SqlParameter>
                                                                { new SqlParameter("TeamID", teamID) });
        }
        public static string MatchTeamUsers(int matchResultID)
        {
            DataTable addresses = SQLcommands.ExecDataTable("MatchTeamUsers",
                                            new List<SqlParameter> { new SqlParameter("MatchResultID", matchResultID) });
            string addressList = "";
            foreach (DataRow address in addresses.Rows)
            {
                addressList += address["eMailAddress"] + ";";
            }

            return addressList.Substring(0, addressList.Length - 1);

        }
        public static DataTable WeeklyResultsForExaminer(int leagueID, int weekNo)
        {
            return SQLcommands.ExecDataTable("WeeklyResultsForExaminer", new List<SqlParameter>{ new SqlParameter("LeagueID",leagueID),
                                                                                                 new SqlParameter("WeekNo",weekNo) });
        }
        public static DataTable MatchPlayed(int HomeTeamID, DateTime MatchPlayedDate) {
            return SQLcommands.ExecDataTable("MatchPlayed", new List<SqlParameter>{ new SqlParameter("HomeTeamID",HomeTeamID),
                                                                                    new SqlParameter("MatchPlayedDate",MatchPlayedDate) });
        }


        #region IDisposable support
        private bool disposedValue; // To detect redundant calls

        // IDisposable
        protected virtual void Dispose(bool disposing)
        {
            if (!disposedValue)
            {
                if (disposing)
                {
                    // TODO: dispose managed state (managed objects).
                }

                // TODO: free unmanaged resources (unmanaged objects) and override Finalize() below.
                // TODO: set large fields to null.
            }

            disposedValue = true;
        }

        // TODO: override Finalize() only if Dispose(disposing As Boolean) above has code to free unmanaged resources.
        // Protected Overrides Sub Finalize()
        // ' Do not change this code.  Put cleanup code in Dispose(disposing As Boolean) above.
        // Dispose(False)
        // MyBase.Finalize()
        // End Sub

        // This code added by Visual Basic to correctly implement the disposable pattern.
        public void Dispose()
        {
            // Do not change this code.  Put cleanup code in Dispose(disposing As Boolean) above.
            Dispose(true);
            // TODO: uncomment the following line if Finalize() is overridden above.
            // GC.SuppressFinalize(Me)
        }
        #endregion
    }
    public class NotePad : IDisposable
    {
        private readonly string user;
        public string Notes;
        public string Administrator;

        public NotePad(string User)
        {
            DataTable dt = SQLcommands.ExecDataTable("AdminNotes", new List<SqlParameter> { new SqlParameter("user", User) });

            user = User;
            if (dt.Rows.Count < 1)
            {
                Notes = "";
                Administrator = User;
            }
            else
            {
                Notes = (string)dt.Rows[0]["Notes"];
                Administrator = (string)dt.Rows[0]["Administrator"];
            }
        }
        public void Update()
        {
            SQLcommands.ExecNonQuery("AdminNotesUpdate", new List<SqlParameter>{ new SqlParameter("user", user),
                                                                                 new SqlParameter("Notes", Notes) });
        }

        #region IDisposable support
        private bool disposedValue; // To detect redundant calls

        // IDisposable
        protected virtual void Dispose(bool disposing)
        {
            if (!disposedValue)
            {
                if (disposing)
                {
                    // TODO: dispose managed state (managed objects).
                }

                // TODO: free unmanaged resources (unmanaged objects) and override Finalize() below.
                // TODO: set large fields to null.
            }

            disposedValue = true;
        }

        // TODO: override Finalize() only if Dispose(disposing As Boolean) above has code to free unmanaged resources.
        // Protected Overrides Sub Finalize()
        // ' Do not change this code.  Put cleanup code in Dispose(disposing As Boolean) above.
        // Dispose(False)
        // MyBase.Finalize()
        // End Sub

        // This code added by Visual Basic to correctly implement the disposable pattern.
        public void Dispose()
        {
            // Do not change this code.  Put cleanup code in Dispose(disposing As Boolean) above.
            Dispose(true);
            // TODO: uncomment the following line if Finalize() is overridden above.
            // GC.SuppressFinalize(Me)
        }
        #endregion 
    }
    public class PageCounter : IDisposable
    {
        public string PageName;
        public int HitCounter;

        public PageCounter(string pageName)
        {
            PageName = pageName;

            object counter = SQLcommands.ExecScalar("HitCounter", new List<SqlParameter> { new SqlParameter("PageName", pageName) });

            if (counter != null)
                HitCounter = (int)counter;
            else
                if (pageName.ToLower().StartsWith("infopage/"))
            {
                // check to see if it's trying to create a spurious subject
                string subject = pageName.Substring(9);
                ContentData cd = new ContentData(subject);
                if (cd.dateTimeLodged != null)
                {
                    HitCounter = 0;
                }
                else
                {
                    HitCounter = -99;
                } // this will cause the merge to be ignored (don't want spurious infopage calls)
            }
            else
            {
                HitCounter = 0;
            }

        }

        public void Merge(int Hitcounter)
        {
            if (Hitcounter >= 0)
                SQLcommands.ExecNonQuery("MergeHomepages", new List<SqlParameter>{ new SqlParameter("Pagename", PageName),
                                                                                   new SqlParameter("Hitcounter", Hitcounter) });
        }

        #region IDisposable support
        private bool disposedValue; // To detect redundant calls

        // IDisposable
        protected virtual void Dispose(bool disposing)
        {
            if (!disposedValue)
            {
                if (disposing)
                {
                    // TODO: dispose managed state (managed objects).
                }

                // TODO: free unmanaged resources (unmanaged objects) and override Finalize() below.
                // TODO: set large fields to null.
            }

            disposedValue = true;
        }

        // TODO: override Finalize() only if Dispose(ByVal disposing As Boolean) above has code to free unmanaged resources.
        // Protected Overrides Sub Finalize()
        // ' Do not change this code.  Put cleanup code in Dispose(ByVal disposing As Boolean) above.
        // Dispose(False)
        // MyBase.Finalize()
        // End Sub

        // This code added by Visual Basic to correctly implement the disposable pattern.
        public void Dispose()
        {
            // Do not change this code.  Put cleanup code in Dispose(disposing As Boolean) above.
            Dispose(true);
            GC.SuppressFinalize(this);
        }
        #endregion 
    }
    public class PasswordReset : IDisposable
    {
        public string emailAddress = "";
        public int ID = 0;
        public DateTime dateRequested = Utilities.UKDateTimeNow(); //DateAndTime.Now;
        public PasswordReset()
        {
        }
        public PasswordReset(string _emailAddress, int id)
        {
            DataTable dt = SQLcommands.ExecDataTable("PasswordReset_Details",
                                                      new List<SqlParameter> { new SqlParameter("emailAddress", _emailAddress),
                                                                               new SqlParameter("TeamID", id)});
            if (dt is object && !(dt.Rows.Count == 0))
            {
                emailAddress = (string)dt.Rows[0]["emailAddress"];
                ID = (int)dt.Rows[0]["TeamID"];
                dateRequested = Convert.ToDateTime(dt.Rows[0]["dateRequested"]);
            }
        }
        public void Insert()
        {
            SQLcommands.ExecNonQuery("PasswordReset_Insert",
                                      new List<SqlParameter> { new SqlParameter("emailAddress", emailAddress),
                                                               new SqlParameter("TeamID", ID)});
        }
        #region IDisposable support
        private bool disposedValue; // To detect redundant calls

        // IDisposable
        protected virtual void Dispose(bool disposing)
        {
            if (!disposedValue)
            {
                if (disposing)
                {
                    // TODO: dispose managed state (managed objects).
                }

                // TODO: free unmanaged resources (unmanaged objects) and override Finalize() below.
                // TODO: set large fields to null.
            }

            disposedValue = true;
        }

        // TODO: override Finalize() only if Dispose(disposing As Boolean) above has code to free unmanaged resources.
        // Protected Overrides Sub Finalize()
        // ' Do not change this code.  Put cleanup code in Dispose(disposing As Boolean) above.
        // Dispose(False)
        // MyBase.Finalize()
        // End Sub

        // This code added by Visual Basic to correctly implement the disposable pattern.
        public void Dispose()
        {
            // Do not change this code.  Put cleanup code in Dispose(disposing As Boolean) above.
            Dispose(true);
            // TODO: uncomment the following line if Finalize() is overridden above.
            // GC.SuppressFinalize(Me)
        }
        #endregion
    }
    public class PayPalCredentials : IDisposable
    {
        public string username;
        public string password;
        public string signature;
        public int timeout;
        public string host;
        public string endPointURL;
        public string ReturnURL;
        public string CancelURL;
        public PayPalCredentials()
        {
            using (HBSAcodeLibrary.HBSA_Configuration cfg = new HBSAcodeLibrary.HBSA_Configuration())
            {
                try
                { timeout = Int32.Parse(cfg.Value("PayPalWebRequestTimeout")); }
                catch (Exception)
                { timeout = 200; }

                if (System.Convert.ToBoolean(cfg.Value("PayPalTesting")))
                {
                    username = cfg.Value("PayPalTestUserName");
                    password = cfg.Value("PayPalTestPassword");
                    signature = cfg.Value("PayPalTestSignature");
                    host = cfg.Value("PayPalTestHost");
                    endPointURL = cfg.Value("PayPalTestEndPointURL");
                    ReturnURL = cfg.Value("PayPalTestReturnURL");
                    CancelURL = cfg.Value("PayPalTestCancelURL");
                }
                else
                {
                    username = cfg.Value("PayPalAPIUserName");
                    password = cfg.Value("PayPalAPIPassword");
                    signature = cfg.Value("PayPalAPISignature");
                    host = cfg.Value("PayPalAPIHost");
                    endPointURL = cfg.Value("PayPalAPIendPointURL");
                    ReturnURL = cfg.Value("PayPalAPIReturnURL");
                    CancelURL = cfg.Value("PayPalAPICancelURL");
                }
            }
        }
        public static int NextPaymentID(int ClubID)
        {
            List<SqlParameter> parameters = new List<SqlParameter>()
            {
                new SqlParameter("ClubID", ClubID),
                new SqlParameter("PaymentID", SqlDbType.Int)
            };
            parameters[1].Direction = ParameterDirection.Output;

            return (int)SQLcommands.ExecScalar("NextPaymentID", parameters);
        }

        #region IDisposable support
        private bool disposedValue; // To detect redundant calls

        // IDisposable
        protected virtual void Dispose(bool disposing)
        {
            if (!disposedValue)
            {
                if (disposing)
                {
                }
            }
            disposedValue = true;
        }

        // TODO: override Finalize() only if Dispose(disposing As Boolean) above has code to free unmanaged resources.
        // Protected Overrides Sub Finalize()
        // ' Do not change this code.  Put cleanup code in Dispose(disposing As Boolean) above.
        // Dispose(False)
        // MyBase.Finalize()
        // End Sub

        // This code added by Visual Basic to correctly implement the disposable pattern.
        public void Dispose()
        {
            // Do not change this code.  Put cleanup code in Dispose(disposing As Boolean) above.
            Dispose(true);
        }
        #endregion
    }
    public class Pictures : IDisposable
    {
        public string Category;
        public string Filename;
        public string Extension;
        public string Description;

        public Pictures(string category, string fileName)
        {
            DataTable ds = SQLcommands.ExecDataTable("GetPictureDetails",
                                                      new List<SqlParameter> { new SqlParameter("Category", category),
                                                                               new SqlParameter("Filename", fileName) });
            Category = category;
            Filename = fileName;
            if (ds is object && ds.Rows.Count > 0)
            {
                Extension = (string)ds.Rows[0]["Extension"];
                Description = (string)ds.Rows[0]["Description"];
            }
            else
            {
                Extension = "";
                Description = "";
            }
        }
        public static DataTable PictureNames(string Category)
        {
            return SQLcommands.ExecDataTable("GetPictureNames",
                                              new List<SqlParameter> { new SqlParameter("Category", Category) });
        }
        public static DataTable Categories()
        {
            return SQLcommands.ExecDataTable("GetPictureCategories");
        }

        public static DataTable PictureCategory(string Category)
        {
            return SQLcommands.ExecDataTable("GetPictureCategory",
                                              new List<SqlParameter> { new SqlParameter("Category", Category) });
        }
        public static void MergePictureCategory(int Sequence, string Category)
        {
            SQLcommands.ExecNonQuery("MergePictureCategory",
                                              new List<SqlParameter> { new SqlParameter("Sequence", Sequence),
                                                                       new SqlParameter("Category", Category) });
        }
        public void Merge(string extension, string description)
        {
            SQLcommands.ExecNonQuery("MergePicture",
                                      new List<SqlParameter> { new SqlParameter("Category", Category),
                                                               new SqlParameter("Filename", Filename),
                                                               new SqlParameter("Extension", extension),
                                                               new SqlParameter("Description", description)});
        }

        #region IDisposable support

        // IDisposable
        bool disposedValue;
        protected virtual void Dispose(bool disposing)
        {
            if (!disposedValue)
            {
                if (disposing)
                {
                    // TODO: dispose managed state (managed objects).
                }

                // TODO: free unmanaged resources (unmanaged objects) and override Finalize() below.
                // TODO: set large fields to null.
            }

            disposedValue = true;
        }

        // TODO: override Finalize() only if Dispose(ByVal disposing As Boolean) above has code to free unmanaged resources.
        // Protected Overrides Sub Finalize()
        // ' Do not change this code.  Put cleanup code in Dispose(ByVal disposing As Boolean) above.
        // Dispose(False)
        // MyBase.Finalize()
        // End Sub

        // This code added by Visual Basic to correctly implement the disposable pattern.
        public void Dispose()
        {
            // Do not change this code.  Put cleanup code in Dispose(disposing As Boolean) above.
            Dispose(true);
            GC.SuppressFinalize(this);
        }
        #endregion
    }
    public class PlayerData : IDisposable
    {
        public int ID;
        public string FullName;
        public string Forename;
        public string Initials;
        public string Surname;
        public int Handicap;
        public string eMail;
        public string TelNo;
        public int Tagged;
        public bool Over70;
        public int ClubID;
        public int SectionID;
        public int LeagueID;
        public string Team;
        public string ClubName;
        public bool Played;
        public string LeagueName;
        public string SectionName;
        public DateTime DateRegistered;
        public string ClubEmail;
        public string TeamEMail;
        public DataTable PlayersTable;
        public PlayerData(int PlayerID)
        {
            CollectData(SQLcommands.ExecDataTable("GetPlayerDetailsByID",
                                                    new List<SqlParameter> { new SqlParameter("PlayerID", PlayerID) })
                       );
        }
        public PlayerData(int SurnameOperator, string Surname, int ForenameOperator, string Forename, int LeagueID = 0)
        {
            CollectData(SQLcommands.ExecDataTable("GetPlayerDetailsByName",
                                                    new List<SqlParameter> { new SqlParameter("SurnameOperator", SurnameOperator),
                                                                             new SqlParameter("Surname", Surname),
                                                                             new SqlParameter("ForenameOperator", ForenameOperator),
                                                                             new SqlParameter("Forename", Forename),
                                                                             new SqlParameter("LeagueID", LeagueID) })
                       );
        }
        private void CollectData(DataTable player)
        {
            PlayersTable = player;
            if (player.Rows.Count > 0)
            {
                ID = (int)(player.Rows[0]["ID"]);
                FullName = (string)player.Rows[0]["fullName"];
                Forename = (string)player.Rows[0]["Forename"];
                Initials = (string)player.Rows[0]["Initials"];
                Surname = (string)player.Rows[0]["Surname"];
                Handicap = (int)player.Rows[0]["Handicap"];
                eMail = player.Rows[0]["eMail"] == DBNull.Value ? "" : (string)player.Rows[0]["eMail"];
                TelNo = player.Rows[0]["TelNo"] == DBNull.Value ? "" : (string)player.Rows[0]["TelNo"];
                Tagged = Convert.ToInt32(player.Rows[0]["Tagged"]);
                Over70 = Convert.ToBoolean(player.Rows[0]["Over70"]);
                ClubID = (int)player.Rows[0]["ClubID"];
                SectionID = (int)player.Rows[0]["SectionID"];
                LeagueID = Convert.ToInt32(player.Rows[0]["LeagueID"]);
                Team = (string)player.Rows[0]["Team"];
                ClubName = (string)player.Rows[0]["Club Name"];
                Played = Convert.ToBoolean(player.Rows[0]["Played"]);
                LeagueName = (string)player.Rows[0]["League Name"];
                SectionName = (string)player.Rows[0]["Section Name"];
                DateRegistered = Convert.ToDateTime(player.Rows[0]["DateRegistered"]);
                ClubEmail = player.Rows[0]["ClubEmail"] == DBNull.Value ? "" : (string)player.Rows[0]["ClubEmail"];
                TeamEMail = player.Rows[0]["TeamEMail"] == DBNull.Value ? "" : (string)player.Rows[0]["TeamEMail"];
            }
        }
        public int Merge(string user)
        {
            List<SqlParameter> parameters = new List<SqlParameter> { new SqlParameter("ID", ID),
                                                                     new SqlParameter("Forename", Forename),
                                                                     new SqlParameter("Initials", Initials),
                                                                     new SqlParameter("Surname", Surname),
                                                                     new SqlParameter("Handicap", Handicap),
                                                                     new SqlParameter("LeagueID", LeagueID),
                                                                     new SqlParameter("SectionID", SectionID),
                                                                     new SqlParameter("ClubID", ClubID),
                                                                     new SqlParameter("Team", Team),
                                                                     new SqlParameter("Tagged", Tagged),
                                                                     new SqlParameter("Over70", Over70),
                                                                     new SqlParameter("Played", Played),
                                                                     new SqlParameter("User", user),
                                                                     new SqlParameter("email", eMail),
                                                                     new SqlParameter("TelNo", TelNo)};
            return (int)SQLcommands.ExecScalar("MergePlayer", parameters);
        }

        public void Delete(string user)
        {
            SQLcommands.ExecNonQuery("DeletePlayer",
                                      new List<SqlParameter>{ new SqlParameter("ID", ID),
                                                              new SqlParameter("User", user) });
        }
        public static List<string> GetSuggestedPlayers(string prefixText, int count, int LeagueId, int SectionID, int ClubID)
        {
            List<string> suggestions = new List<string>();
            string[] TextWords = prefixText.Split(' ');
            List<SqlParameter> parameters = new List<SqlParameter>
            {
                new SqlParameter("LeagueId", LeagueId),
                new SqlParameter("SectionID", SectionID),
                new SqlParameter("ClubID", ClubID),
                new SqlParameter("count", count),
                new SqlParameter("word1", TextWords[0])
            };
            if (TextWords.Count() > 1)
            {
                parameters.Add(new SqlParameter("word2", TextWords[1]));
                if (TextWords.Count() > 2)
                    parameters.Add(new SqlParameter("word3", TextWords[2]));
            }

            DataTable players = SQLcommands.ExecDataTable("SuggestPlayers", parameters);
            foreach (DataRow player in players.Rows)
            {
                suggestions.Add((string)player["Player"]);
                if (suggestions.Count >= count)
                    break;
            };

            return suggestions;
        }
        public static List<string> RequestRegistration_SuggestPlayers(string prefixText, int count, int LeagueId)
        {
            List<string> suggestions = new List<string>();
            string[] TextWords = prefixText.Split(" ".ToCharArray());
            List<SqlParameter> parameters = new List<SqlParameter>
            {
                new SqlParameter("LeagueId", LeagueId),
                new SqlParameter("count", count),
                new SqlParameter("word1", TextWords[0])
            };
            if (TextWords.Count() > 1)
            {
                parameters.Add(new SqlParameter("word2", TextWords[1]));
                if (TextWords.Count() > 2)
                    parameters.Add(new SqlParameter("word3", TextWords[2]));
            }

            DataTable players = SQLcommands.ExecDataTable("RequestRegistration_SuggestPlayers", parameters);
            foreach (DataRow player in players.Rows)
            {
                suggestions.Add((string)player["Player"]);
            }

            return suggestions;

        }
        public static List<string> GetSuggestedEntrants(string prefixText, int count, int CompetitionID)
        {
            List<string> suggestions = new List<string>();
            string[] TextWords = prefixText.Split(' ');
            List<SqlParameter> parameters = new List<SqlParameter>
            {
                new SqlParameter("CompetitionID", CompetitionID),
                new SqlParameter("count", count),
                new SqlParameter("word1", TextWords[0])
            };
            if (TextWords.Count() > 1)
            {
                parameters.Add(new SqlParameter("word2", TextWords[1]));
                if (TextWords.Count() > 2)
                    parameters.Add(new SqlParameter("word3", TextWords[2]));
            }

            try
            {
                DataTable entrants = SQLcommands.ExecDataTable("SuggestEntrants", parameters);
                foreach (DataRow entrant in entrants.Rows)
                {
                    suggestions.Add((string)entrant["Entrant"]);
                    if (suggestions.Count >= count)
                        break;
                };
            }
            catch (Exception ex)
            {
                suggestions.Add(ex.Message);
            }
            return suggestions;
        }
        public static List<string> GetSuggestedHistoricalPlayers(string prefixText, int count, int LeagueId)
        {
            List<string> suggestions = new List<string>();
            string[] TextWords = prefixText.Split(' ');
            List<SqlParameter> parameters = new List<SqlParameter>
            {
                new SqlParameter("LeagueId", LeagueId),
                new SqlParameter("count", count),
                new SqlParameter("word1", TextWords[0])
            };
            if (TextWords.Count() > 1)
            {
                parameters.Add(new SqlParameter("word2", TextWords[1]));
                if (TextWords.Count() > 2)
                    parameters.Add(new SqlParameter("word3", TextWords[2]));
            }

            DataTable players = SQLcommands.ExecDataTable("SuggestPlayerRecord", parameters);
            foreach (DataRow player in players.Rows)
            {
                suggestions.Add((string)player["Player"]);
                if (suggestions.Count >= count)
                    break;
            };

            return suggestions;
        }
        public static DataTable TaggedPlayersReport(int LeagueID, int SectionID, int ClubID, bool ActionNeeded, string Player = "")
        {
            return SQLcommands.ExecDataTable("TaggedPlayersReport",
                                             new List<SqlParameter> { new SqlParameter("LeagueID", LeagueID),
                                                                      new SqlParameter("SectionID", SectionID),
                                                                      new SqlParameter("ClubID", ClubID),
                                                                      new SqlParameter("ActionNeeded", ActionNeeded),
                                                                      new SqlParameter("Player", Player) });
        }
        public static string ApplyTaggedPlayersHandicaps(int SectionID = 0, int ClubID = 0)
        {
            DataTable TaggedPlayersTable = SQLcommands.ExecDataTable
                                            ("ApplyTaggedPlayersNewHandicaps",
                                            new List<SqlParameter> { new SqlParameter("LeagueID", SectionID > 99 ? SectionID % 100 : 0),
                                                                     new SqlParameter("SectionID", SectionID > 99 ? 0 : SectionID % 100),
                                                                     new SqlParameter("ClubID", ClubID)});
            string ApplyTaggedPlayersHandicapsRet;
            if (TaggedPlayersTable.Rows.Count == 0)
                ApplyTaggedPlayersHandicapsRet = "<br/><font color=red><strong>No changes made, Nothing To change.</font>";
            else
            {
                ApplyTaggedPlayersHandicapsRet = "<br/><font color=green><strong>Changes made,</font>";

                // Send informing emails
                string SendErrors = "";
                foreach (DataRow Player in TaggedPlayersTable.Rows)
                {
                    string err = HBSAcodeLibrary.Emailer.SendPlayerMaintenanceEmail("handicapChange", "",
                                                                                 (string)Player["ClubLoginEmail"],
                                                                                 (string)Player["TeamEMail"],
                                                                                 (string)Player["PlayereMail"],
                                                                                 (string)Player["Player"],
                                                                                 (string)Player["Team"],
                                                                                 Convert.ToString(Player["Handicap"]),
                                                                                 Convert.ToString(Player["NewHandicap"]),
                                                                                 (string)Player["Section"]);
                    if (!string.IsNullOrEmpty(err))
                    {
                        SendErrors += "<br/>" + err;
                    }
                }

                if (string.IsNullOrEmpty(SendErrors))
                {
                    ApplyTaggedPlayersHandicapsRet += "<br/><font color=green><strong> And emails sent.</strong></font><br/>";
                }
                else
                {
                    ApplyTaggedPlayersHandicapsRet += SendErrors;
                }
            }

            return ApplyTaggedPlayersHandicapsRet == "" ? TaggedPlayersTable.Rows.Count.ToString() : ApplyTaggedPlayersHandicapsRet;
        }
        public static DataTable GetPlayersByClubAndTeam(int ClubID, int SectionID = -1, string Team = "")
        {
            if (SectionID == -1) {
                return SQLcommands.ExecDataTable("GetPlayersByClub",
                                               new List<SqlParameter> { 
                                                   new SqlParameter("ClubID", ClubID)
                                                                      });
            } else {
                return SQLcommands.ExecDataTable("GetPlayersByClubAndTeam",
                                            new List<SqlParameter> {
                                                new SqlParameter("SectionID", SectionID),
                                                new SqlParameter("ClubID", ClubID),
                                                new SqlParameter("Team", Team) 
                                                                    });
            }
        }
        public static DataTable GetPlayerDetails (int SectionID = 0, int ClubID = 0)
        {
            return SQLcommands.ExecDataTable("GetPlayerDetails",
                                            new List<SqlParameter> { new SqlParameter("LeagueID", SectionID > 99 ? SectionID % 100 : 0),
                                                                     new SqlParameter("SectionID", SectionID > 99 ? 0 : SectionID % 100),
                                                                     new SqlParameter("ClubID", ClubID)});
        }
        public static DataTable GetPlayerDetailsByPlayer(int SectionID = 0, int ClubID = 0, string player = "", bool basic = false, bool mobile = false)
        {
            return SQLcommands.ExecDataTable("GetPlayerDetailsByPlayer",
                                            new List<SqlParameter> { new SqlParameter("LeagueID", SectionID > 99 ? SectionID % 100 : 0),
                                                                     new SqlParameter("SectionID", SectionID > 99 ? 0 : SectionID % 100),
                                                                     new SqlParameter("ClubID", ClubID),
                                                                     new SqlParameter("Player",player),
                                                                     new SqlParameter("mobile",mobile),
                                                                     new SqlParameter("basic",basic)});
        }
        public static string ApplyNewPlayerTags()
        {
            try
            {
                SQLcommands.ExecNonQuery("ApplyNewPlayerTags");
                return "";
            }
            catch (Exception ex)
            {
                return ex.Message;
            }
        }
        public static DataTable HandicapsReport(int sectionID)
        {
            List<SqlParameter> parameters = new List<SqlParameter> { };
            if (sectionID >= 100)
            {
                parameters.Add(new SqlParameter("LeagueID", sectionID - 100));
                parameters.Add(new SqlParameter("SectionID", 0));
            }
            else
            {
                parameters.Add(new SqlParameter("LeagueID", 0));
                parameters.Add(new SqlParameter("SectionID", sectionID));
            }
            return SQLcommands.ExecDataTable("HandicapsReport", parameters);
        }
        public static DataTable HandicapsReportForWeb(int sectionID, int clubID,
                                                      bool searchByName = false, string player="",
                                                      bool changesOnly=false )
        {
            List<SqlParameter> parameters = new List<SqlParameter> {
                new SqlParameter("ChangesOnly",changesOnly),
                new SqlParameter("ClubID",clubID),
            };
            if (sectionID >= 100)
            {
                parameters.Add(new SqlParameter("LeagueID", sectionID - 100));
                parameters.Add(new SqlParameter("SectionID", 0));
            }
            else
            {
                parameters.Add(new SqlParameter("LeagueID", 0));
                parameters.Add(new SqlParameter("SectionID", sectionID));
            }
            if (searchByName)
            {
                parameters.Add(new SqlParameter("Player", player));
            }

            return SQLcommands.ExecDataTable("HandicapsReportForWeb", parameters);
        }
        public static DataTable HandicapsReportForMobile(int sectionID, int clubID,
                                                      bool searchByName = false, string player = "",
                                                      bool changesOnly = false)
        {
            List<SqlParameter> parameters = new List<SqlParameter> {
                new SqlParameter("ChangesOnly",changesOnly),
                new SqlParameter("ClubID",clubID),
            };
            if (sectionID >= 100)
            {
                parameters.Add(new SqlParameter("LeagueID", sectionID - 100));
                parameters.Add(new SqlParameter("SectionID", 0));
            }
            else
            {
                parameters.Add(new SqlParameter("LeagueID", 0));
                parameters.Add(new SqlParameter("SectionID", sectionID));
            }
            if (searchByName)
            {
                parameters.Add(new SqlParameter("Player", player));
            }

            return SQLcommands.ExecDataTable("HandicapsReportForMobile", parameters);
        }
        public static void UpdateHandicaps(int sectionID)
        {
            List<SqlParameter> parameters = new List<SqlParameter> { };
            if (sectionID >= 100)
            {
                parameters.Add(new SqlParameter("LeagueID", sectionID - 100));
                parameters.Add(new SqlParameter("SectionID", 0));
            }
            else
            {
                parameters.Add(new SqlParameter("LeagueID", 0));
                parameters.Add(new SqlParameter("SectionID", sectionID));
            }
            SQLcommands.ExecNonQuery("UpdateHandicaps", parameters);
        }
        public static DataTable GetPlayerRecordsSeasons(int leagueID)
        {
            return SQLcommands.ExecDataTable("GetPlayerRecordsSeasons",
                                              new List<SqlParameter> { new SqlParameter("LeagueID", leagueID) });
        }
        public static DataTable GetPlayerRecords(int leagueID, int season = 0, string player = "")
        {
            return SQLcommands.ExecDataTable("GetPlayerRecords",
                                              new List<SqlParameter> { new SqlParameter("LeagueID", leagueID),
                                                                       new SqlParameter("Season", season),
                                                                       new SqlParameter("Player", player)});
        }
        public static DataTable GetPlayingRecords(int sectionID, int clubID, string team,
                                                  string player, bool tagged, bool over70,
                                                  bool forMobile, object handicap = null)
        {
            List<SqlParameter> parameters = new List<SqlParameter> {
                                                 new SqlParameter("SectionID",sectionID),
                                                 new SqlParameter("ClubID",clubID),
                                                 new SqlParameter("Team",team),
                                                 new SqlParameter("Player",player),
                                                 new SqlParameter("Tagged",tagged),
                                                 new SqlParameter("Over70",over70),
                                             };
            if (forMobile)
                parameters.Add(new SqlParameter("ForMobile", true));
            if (handicap != null)
                parameters.Add(new SqlParameter("Handicap", Convert.ToInt32(handicap)));

            return SQLcommands.ExecDataTable("PlayingRecords", parameters);
        }
        public static DataTable GetPlayingRecordsDetail(int sectionID, int clubID, string team,
                                                  string player, bool tagged, bool over70,
                                                  object handicap)
        {
            List<SqlParameter> parameters = new List<SqlParameter> {
                                                 new SqlParameter("SectionID",sectionID),
                                                 new SqlParameter("ClubID",clubID),
                                                 new SqlParameter("Team",team),
                                                 new SqlParameter("Player",player),
                                                 new SqlParameter("Tagged",tagged),
                                                 new SqlParameter("Over70",over70),
                                             };
            if (handicap != null)
                parameters.Add(new SqlParameter("Handicap", Convert.ToInt32(handicap)));

            return SQLcommands.ExecDataTable("PlayingRecordsDetail", parameters);
        }
        public static DataTable NewPlayers()
        {
            return SQLcommands.ExecDataTable("NewPlayers");
        }

        #region IDisposable support
        private bool disposedValue = false;        // To detect redundant calls

        // IDisposable
        protected virtual void Dispose(bool disposing)
        {
            if (!disposedValue)
            {
                if (disposing)
                {
                    // TODO: free other state (managed objects).
                }

                // TODO: free your own state (unmanaged objects).
                // TODO: set large fields to null.
            }

            disposedValue = true;
        }

        // This code added by Visual Basic to correctly implement the disposable pattern.
        public void Dispose()
        {
            // Do not change this code.  Put cleanup code in Dispose(ByVal disposing As Boolean) above.
            Dispose(true);
            GC.SuppressFinalize(this);
        }
        #endregion
    }
    public class SectionData : IDisposable
    {
        public int ID;
        public string SectionName;
        public int LeagueID;
        public bool ReversedMatrix;
        public DataTable Teams;
        public DataTable Players;
        public SectionData()
        {
            // No ID, do nothing, just instatiates the class
        }
        public SectionData(int SectionID)
        {
            if (SectionID == -1) { 
                // special case for competitions only teams
                ID = -1;
                LeagueID = -1;
                SectionName = "**Competitions only**";
            } else
                GetSectionData(SectionID);
        }
        public void GetSectionData(int SectionID)
        {
            DataSet sectionData = SQLcommands.ExecDataSet("SectionDetails",
                                                        new List<SqlParameter> { new SqlParameter("ID", SectionID) });
            DataRow section = sectionData.Tables[0].Rows[0];
            ID = (int)section["ID"];
            LeagueID = (int)section["LeagueID"];
            ReversedMatrix = Convert.ToBoolean(section["ReversedMatrix"]);
            SectionName = (string)section["Section Name"];

            Teams = sectionData.Tables[1];
            Players = sectionData.Tables[2];
        }
        public string Merge()
        {
            return (string)SQLcommands.ExecScalar("MergeSection",
                                                    new List<SqlParameter> { new SqlParameter("SectionID", ID),
                                                                             new SqlParameter("LeagueID", LeagueID),
                                                                             new SqlParameter("SectionName", SectionName),
                                                                             new SqlParameter("ReversedMatrix", ReversedMatrix)});
        }
        public static DataTable GetSections()
        {
            return SQLcommands.ExecDataTable("GetAllSections");
        }
        public static DataTable SectionList(int SectionID)
        {
            List<SqlParameter> parameters = new List<SqlParameter> { };
            if (SectionID > 99)
                parameters.Add(new SqlParameter("LeagueID", SectionID - 100));
            else
                parameters.Add(new SqlParameter("SectionID", SectionID));

            return SQLcommands.ExecDataTable("SectionList", parameters);
        }
        public static void AssignFixtureGrid(int SectionID)
        {
            SQLcommands.ExecNonQuery("AssignFixtureGrid",
                                      new List<SqlParameter> { new SqlParameter("SectionID", SectionID) });
        }

        #region IDisposable support
        private bool disposedValue = false;        // To detect redundant calls

        // IDisposable
        protected virtual void Dispose(bool disposing)
        {
            if (!disposedValue)
            {
                if (disposing)
                {
                    // TODO: free other state (managed objects).
                }

                // TODO: free your own state (unmanaged objects).
                // TODO: set large fields to null.
            }

            disposedValue = true;
        }
        // This code added by Visual Basic to correctly implement the disposable pattern.
        public void Dispose()
        {
            // Do not change this code.  Put cleanup code in Dispose(ByVal disposing As Boolean) above.
            Dispose(true);
            GC.SuppressFinalize(this);
        }
        #endregion
    }
    public class SessionInfo : IDisposable
    {
        public static void Open(string SessionID, string Client, string OSInfo, string device, string brand, string model)
        {
            SQLcommands.ExecNonQuery("NewSession",
                                      new List<SqlParameter> { new SqlParameter("SessionID", SessionID),
                                                               new SqlParameter("Client", Client is null ? "NULL" : Client),
                                                               new SqlParameter("OSInfo", OSInfo is null ? "NULL" : OSInfo),
                                                               new SqlParameter("device", device is null ? "NULL" : device),
                                                               new SqlParameter("brand", brand is null ? "NULL" : brand),
                                                               new SqlParameter("model", model is null ? "NULL" : model) });
        }
        public static void Close(string SessionID)
        {
            SQLcommands.ExecNonQuery("NewSession",
                                      new List<SqlParameter> { new SqlParameter("SessionID", SessionID) });
        }
        public static bool SessionIDexists(string SessionID)
        {
            return Convert.ToBoolean(SQLcommands.ExecScalar("SessionIDexists",
                                                             new List<SqlParameter> { new SqlParameter("SessionID", SessionID) }));
        }

        #region IDisposable support
        private bool disposedValue; // To detect redundant calls

        // IDisposable
        protected virtual void Dispose(bool disposing)
        {
            if (!disposedValue)
            {
                if (disposing)
                {
                    // TODO: dispose managed state (managed objects).
                }

                // TODO: free unmanaged resources (unmanaged objects) and override Finalize() below.
                // TODO: set large fields to null.
            }

            disposedValue = true;
        }

        // TODO: override Finalize() only if Dispose(ByVal disposing As Boolean) above has code to free unmanaged resources.
        // Protected Overrides Sub Finalize()
        // ' Do not change this code.  Put cleanup code in Dispose(ByVal disposing As Boolean) above.
        // Dispose(False)
        // MyBase.Finalize()
        // End Sub

        // This code added by Visual Basic to correctly implement the disposable pattern.
        public void Dispose()
        {
            // Do not change this code.  Put cleanup code in Dispose(disposing As Boolean) above.
            Dispose(true);
            GC.SuppressFinalize(this);
        }
        #endregion
    }
    public class Settings : IDisposable
    {
        public DataTable categories;
        public DataTable settings;
        public Settings()
        {
            GetSettings();
        }
        private void GetSettings() 
        {
            DataSet allSettings = SQLcommands.ExecDataSet("GetSettings");
            categories = allSettings.Tables[0];
            settings = allSettings.Tables[1];
        }
        public DataTable SettingsByCategory(string category)
        {
            return settings.Select("Category = '" + category + "'").CopyToDataTable();
        }
        public void AddSetting (string Category, string Setting, string ControlType, String ConfigKey, string SettingValue)
        {
            //call stored proc to add it
            SQLcommands.ExecNonQuery("MergeConfigSettings",
                                     new List<SqlParameter> { new SqlParameter("Category", Category),
                                                              new SqlParameter("Setting", Setting),
                                                              new SqlParameter("ControlType", ControlType),
                                                              new SqlParameter("ConfigKey", ConfigKey),
                                                              new SqlParameter("SettingValue", SettingValue)
                                                             });
            //show new setting
            GetSettings();
        }

        
        #region IDisposable support
        private bool disposedValue; // To detect redundant calls

        // IDisposable
        protected virtual void Dispose(bool disposing)
        {
            if (!disposedValue)
            {
                if (disposing)
                {
                    // TODO: dispose managed state (managed objects).
                }

                // TODO: free unmanaged resources (unmanaged objects) and override Finalize() below.
                // TODO: set large fields to null.
            }

            disposedValue = true;
        }

        // TODO: override Finalize() only if Dispose(disposing As Boolean) above has code to free unmanaged resources.
        // Protected Overrides Sub Finalize()
        // ' Do not change this code.  Put cleanup code in Dispose(disposing As Boolean) above.
        // Dispose(False)
        // MyBase.Finalize()
        // End Sub

        // This code added by Visual Basic to correctly implement the disposable pattern.
        public void Dispose()
        {
            // Do not change this code.  Put cleanup code in Dispose(disposing As Boolean) above.
            Dispose(true);
            // TODO: uncomment the following line if Finalize() is overridden above.
            // GC.SuppressFinalize(Me)
        }
        #endregion
    }
    public class TeamData : IDisposable
    {
        public int ID;
        public int LeagueID;
        public string LeagueName;
        public int SectionID;
        public string SectionName;
        public int ClubID;
        public string ClubName;
        public string Team;
        public int FixtureNo;
        public string Contact;
        public string eMail;
        public string TelNo;
        public int Captain;
        public DataTable Players;
        private void FillTeamDataDetails(DataSet TeamData)
        {
            if (TeamData.Tables[0].Rows.Count > 0)
            {
                var team = TeamData.Tables[0].Rows[0];
                ID = (int)team["TeamID"];
                LeagueID = (int)team["LeagueID"];
                LeagueName = (string)team["League Name"];
                SectionID = (int)team["SectionID"];
                SectionName = (string)team["Section Name"];
                ClubID = (int)team["ClubID"];
                ClubName = (string)team["Club Name"];
                Team = (string)team["team"];
                FixtureNo = (int)team["FixtureNo"];
                Contact = (string)team["Contact"];
                eMail = (string)team["eMail"];
                TelNo = (string)team["TelNo"];
                Captain = DBNull.Value == team["Captain"] ? 0 : (int)team["Captain"];
            }
            else
                ID = 0;  //indicates no team with these selection criteria

            Players = TeamData.Tables[1];
        }
        public TeamData()
        {

        }
        public TeamData(int TeamID)
        {
            // Given a team ID, get that team's details
            FillTeamDataDetails(SQLcommands.ExecDataSet("TeamDetails",
                                                            new List<SqlParameter> {
                                                                new SqlParameter("TeamID", TeamID)
                                                            }));
        }
        public TeamData(int SectionID, int ClubID, string team)
        {
            //Given Section, Club & team letter find team details
            using (SectionData S = new SectionData(SectionID))
            {
                FillTeamDataDetails(SQLcommands.ExecDataSet("TeamDetails",
                                                           new List<SqlParameter> {
                                                                new SqlParameter("LeagueID", S.LeagueID),
                                                                new SqlParameter("ClubID", ClubID),
                                                                new SqlParameter("team", team)
                                                           }));
            }
        }
        public TeamData(int sectionID, int WeekNo, int HomeTeamID)
        {
            // Given a section, week and home team ID get the away team details

            FillTeamDataDetails(SQLcommands.ExecDataSet("GetAwayTeam",
                                                                new List<SqlParameter> {
                                                                    new SqlParameter("SectionID", sectionID),
                                                                    new SqlParameter("HomeTeamID", HomeTeamID),
                                                                    new SqlParameter("WeekNo", WeekNo)
                                                                                         }));
        }
        public string Merge(string User = "")
        {
            var parameters = new List<SqlParameter> {
                                    new SqlParameter("TeamID", ID),           // Note that if this is -1 it will Insert a new Team with a new ID
                                    new SqlParameter("SectionID", SectionID), // Note that if this is -100 it will delete the Team with the given ID
                                    new SqlParameter("FixtureNo", FixtureNo),
                                    new SqlParameter("ClubID", ClubID),
                                    new SqlParameter("Team", Team),
                                    new SqlParameter("Captain", Captain)
                                   };
            if (!string.IsNullOrEmpty(User))
                parameters.Add(new SqlParameter("User", User));

            DataTable result = SQLcommands.ExecDataTable("MergeTeam", parameters);

            if (result.Rows.Count > 0)
                if (Convert.ToString(result.Rows[0][0]) == "INSERT")
                    return Convert.ToString(result.Rows[0][1]);
                else
                    return (string)result.Rows[0][0];
            else
                return null;
        }
        public string Remove(string User)
        {
            SQLcommands.ExecNonQuery("removeTeam", new List<SqlParameter> { new SqlParameter("TeamID", ID),
                                                                            new SqlParameter("User", User) });
           return "DELETED";
        }
        public void MoveTeam(int NewClubID, int NewSectionID, string NewTeam)
        {
            SQLcommands.ExecNonQuery("MoveTeam", new List<SqlParameter> { 
                    new SqlParameter("TeamID", ID),        // Note that if this is -1 it will Insert a new Team with the given ID
                    new SqlParameter("NewClubID", NewClubID),  // Note that if this is -1 it will delete the Team with the given ID
                    new SqlParameter("NewSectionID", NewSectionID),
                    new SqlParameter("NewTeam", NewTeam) });
        }
        public void UpdateLeaguePointsAdjustment (decimal points, string comment, string createdBy)
        {
            SQLcommands.ExecNonQuery("updateLeaguePointsAdjustment",
                new List<SqlParameter> {
                    new SqlParameter("TeamID",ID),
                    new SqlParameter("Points",points),
                    new SqlParameter("Comment",comment),
                    new SqlParameter("CreatedBy", createdBy )});
        }
        public static DataSet GetTeamTables(int LeagueID)
        {
            using (var TeamsTables = SQLcommands.ExecDataSet("GetTeamsTables",
                                                               new List<SqlParameter> { 
                                                                   new SqlParameter("LeagueID", LeagueID) }))
            {
                try
                {
                    // get rid of DBNnulls
                    for (int tbl = 0; tbl < TeamsTables.Tables.Count; tbl++)
                        for (int row = 0; row < TeamsTables.Tables[tbl].Rows.Count; row++)
                            for (int col = 0; col < TeamsTables.Tables[tbl].Rows[row].ItemArray.Length; col++)
                                if (DBNull.Value == TeamsTables.Tables[tbl].Rows[row][col])
                                    TeamsTables.Tables[0].Rows[row][col] = "";
                }
                catch (Exception)
                {
                }
                return TeamsTables;
            }
        }
        public static DataTable GetTeams(int sectionID)
        {
            return SQLcommands.ExecDataTable("GetTeams", new List<SqlParameter> {
                                                            new SqlParameter("SectionID", sectionID) });
        }
        public static DataTable GetAllTeams(int sectionID)
        {
            return SQLcommands.ExecDataTable("GetAllTeams",
                                            new List<SqlParameter> { new SqlParameter("LeagueID", sectionID > 99 ? sectionID % 100 : 0),
                                                                     new SqlParameter("SectionID", sectionID > 99 ? 0 : sectionID % 100) });

        }
        public static void SequenceTeamsInSection(int SectionID)
        {
            SQLcommands.ExecNonQuery("SequenceTeamsInSection", 
                                      new List<SqlParameter> { new SqlParameter("SectionID", SectionID) });
        }
        public static DataTable TeamLetters(int SectionID, int ClubID, int LeagueID = 0)
        {
            return SQLcommands.ExecDataTable("GetTeamLetters",
                                      new List<SqlParameter> { new SqlParameter("SectionID", SectionID),
                                                               new SqlParameter("ClubID", ClubID),
                                                               new SqlParameter("LeagueID", LeagueID)});
        }
        public static DataTable LookForTooManyHomeFixtures (int leagueID)
        {
            return SQLcommands.ExecDataTable("LookForTooManyHomeFixtures",
                                              new List<SqlParameter> { new SqlParameter("LeagueID", leagueID) });
        }

        #region IDisposable support
        private bool disposedValue = false;        // To detect redundant calls

        // IDisposable
        protected virtual void Dispose(bool disposing)
        {
            if (!disposedValue)
            {
                if (disposing)
                {
                    // TODO: free other state (managed objects).
                }

                // TODO: free your own state (unmanaged objects).
                // TODO: set large fields to null.
            }

            disposedValue = true;
        }
        // This code added by Visual Basic to correctly implement the disposable pattern.
        public void Dispose()
        {
            // Do not change this code.  Put cleanup code in Dispose(ByVal disposing As Boolean) above.
            Dispose(true);
            GC.SuppressFinalize(this);
        }
#endregion 
    }
    public class UserData : IDisposable
    {
        public bool loggedIn;
        public int TeamID;
        public string eMail;
        public string NewPassword;
        private readonly string OriginalHashedPassword;
        public bool Confirmed;
        public string ConfirmCode;
        public string FirstName;
        public string Surname;
        public string Telephone;
        public int UserID;
        public UserData() { }
        public UserData(string eMailAddress = "", string _Password = "", int id = 0)
        {
            List<SqlParameter> parameters = new List<SqlParameter>();
            if (eMailAddress != "") parameters.Add(new SqlParameter("eMailAddress", eMailAddress));
            if (id > 0) parameters.Add(new SqlParameter("ID", id));
            else parameters.Add(new SqlParameter("Password", HBSAcodeLibrary.Utilities.RFC2898_Hash(_Password)));

            using (DataTable users = SQLcommands.ExecDataTable("checkLogin", parameters))
            {
                if (users != null && users.Rows.Count > 0)
                {
                    DataRow user = users.Rows[0];
                    TeamID = int.Parse(user["TeamID"].ToString());  //dr.TeamID;
                    eMail = user["eMailAddress"].ToString();
                    OriginalHashedPassword = user["Password"].ToString();
                    ConfirmCode = user["Confirmed"].ToString();
                    if (user["Confirmed"].ToString() == "Confirmed") { Confirmed = true; };
                    Confirmed = user["Confirmed"].ToString() == "Confirmed";
                    FirstName = user["FirstName"].ToString();
                    Surname = user["Surname"].ToString();
                    Telephone = user["Telephone"].ToString();
                    UserID = int.Parse(user["ID"].ToString());

                    loggedIn = true;
                }
                else
                    loggedIn = false;

            }
        }
        public void ConfirmUser()
        {
            List<SqlParameter> parameters = new List<SqlParameter>()
            {
                new SqlParameter("eMailAddress", eMail),
                new SqlParameter("Password", OriginalHashedPassword),
                new SqlParameter("ConfirmCode", ConfirmCode)
            };

            SQLcommands.ExecNonQuery("confirmLogin", parameters);

        }
        public int CreateUser(string RandomKey)
        {
            // create the new login
            List<SqlParameter> parameters = new List<SqlParameter>()
            {
                new SqlParameter("eMailAddress", eMail),
                new SqlParameter("Password", HBSAcodeLibrary.Utilities.RFC2898_Hash(NewPassword)),
                new SqlParameter("TeamID", TeamID),
                new SqlParameter("Confirmed", RandomKey),
                new SqlParameter("FirstName", FirstName),
                new SqlParameter("Surname", Surname),
                new SqlParameter("Telephone", Telephone)
            };

            return (int)SQLcommands.ExecScalar("CreateUser", parameters);
        }
        public void UpdateUser(string ConfirmCode = "")
        {
            if (NewPassword != "" && Utilities.RFC2898_Hash(NewPassword) == OriginalHashedPassword)
            {
                NewPassword = "";
            }
            List<SqlParameter> parameters = new List<SqlParameter>()
            {
                new SqlParameter("eMailAddress", eMail),
                new SqlParameter("OriginalPassword", OriginalHashedPassword),
                new SqlParameter("Password", NewPassword.Trim() == "" ? "" : Utilities.RFC2898_Hash(NewPassword)),
                new SqlParameter("TeamID", TeamID),
                new SqlParameter("FirstName", FirstName),
                new SqlParameter("Surname", Surname),
                new SqlParameter("Telephone", Telephone)
            };
            if (ConfirmCode != "")
                parameters.Add(new SqlParameter("ConfirmCode", ConfirmCode));

            SQLcommands.ExecNonQuery("UpdateLogin", parameters);

        }
        public void DeleteUser()
        {
            List<SqlParameter> parameters = new List<SqlParameter>()
            {
                new SqlParameter("eMailAddress", eMail),
                new SqlParameter("Password", OriginalHashedPassword),
            };

            SQLcommands.ExecNonQuery("DeleteLogin", parameters);
        }
        public static DataTable UserList(int ClubID, string Team, int LeagueID, string Type, string Confirmed)
        {
            List<SqlParameter> parameters = new List<SqlParameter>()
            {
                new SqlParameter("ClubID", ClubID),
                new SqlParameter("Team", Team),
                new SqlParameter("LeagueID", LeagueID),
                new SqlParameter("UserType", Type),
                new SqlParameter("Confirmed", Confirmed)
            };

            return SQLcommands.ExecDataTable("ReportUserDetails", parameters);
        }
        public static DataTable UsersClubsTeams(string Type)
        {
            List<SqlParameter> parameters = new List<SqlParameter>()
            {
                new SqlParameter("UserType", Type)
            };

            return SQLcommands.ExecDataTable("UsersClubsTeams", parameters);

        }
        public static DataRow LoginData(int ID)
        {
            List<SqlParameter> parameters = new List<SqlParameter>()
            {
                new SqlParameter("ID", ID)
            };

            return SQLcommands.ExecDataTable("loginDetails", parameters).Rows[0];

        }
        public static DataRow LoginData(string eMailAddress, int TeamID)
        {
            List<SqlParameter> parameters = new List<SqlParameter>()
            {
                new SqlParameter("eMailAddress", eMailAddress),
                new SqlParameter("TeamID", TeamID)
            };

            return SQLcommands.ExecDataTable("loginDetails", parameters).Rows[0];

        }
        public static void LoginPasswordReset(int UserID, string Password)
        {
            List<SqlParameter> parameters = new List<SqlParameter>()
            {
                new SqlParameter("Password", Password),
                new SqlParameter("UserID", UserID)
            };

            SQLcommands.ExecNonQuery("LoginPasswordReset", parameters);
        }

        #region IDisposable implementation 
        private bool isDisposed = false;
        public void Dispose()
        {
            Dispose(true);
            GC.SuppressFinalize(this);
        }
        protected virtual void Dispose(bool disposing)
        {
            if (!isDisposed)
            {
                if (disposing)
                {
                    //TODO: dispose managed objects
                }
                //TODO: free unmanaged resources (unmanaged objects)
                //TODO: set large fields to null.
            }
            isDisposed = true;
        }
        #endregion
    }

}

using System;
using System.Collections;
using System.Text;
using System.Security.Cryptography;
using System.IO;
using System.Web; 
using System.Data;
using Microsoft.VisualBasic;

namespace HBSAcodeLibrary
{
    public class AES_EncryptDecrypt : IDisposable
    {
        private readonly string _EncryptionKey;
        private readonly byte[] _saltBytes;
        private readonly Aes encryptor = Aes.Create();

        public AES_EncryptDecrypt(string EncryptionKey, string salt)
        {
            _EncryptionKey = EncryptionKey;
            _saltBytes = Encoding.Unicode.GetBytes(salt);

            Rfc2898DeriveBytes pdb = new Rfc2898DeriveBytes(_EncryptionKey, _saltBytes);
            encryptor.Key = pdb.GetBytes(32);
            encryptor.IV = pdb.GetBytes(16);
        }

        public string EncryptData(string clearText)
        {
            byte[] clearBytes = Encoding.Unicode.GetBytes(clearText);

            using (MemoryStream ms = new MemoryStream())
            {
                using (CryptoStream cs = new CryptoStream(ms, encryptor.CreateEncryptor(), CryptoStreamMode.Write))
                {
                    cs.Write(clearBytes, 0, clearBytes.Length);
                    cs.Close();
                }
                clearText = Convert.ToBase64String(ms.ToArray());
            }

            return clearText;
        }

        public string DecryptData(string cipherText)
        {
            byte[] cipherBytes = Convert.FromBase64String(cipherText.Replace(" ", ""));

            using (MemoryStream ms = new MemoryStream())
            {
                using (CryptoStream cs = new CryptoStream(ms, encryptor.CreateDecryptor(), CryptoStreamMode.Write))
                {
                    cs.Write(cipherBytes, 0, cipherBytes.Length);
                    cs.Close();
                }
                cipherText = Encoding.Unicode.GetString(ms.ToArray());
            }

            return cipherText;
        }

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
    }
    public class SiteRootURL
    {
        public static string GetSiteRootUrl()
        {
            StringBuilder URL = new StringBuilder("http");

            if ((HttpContext.Current.Request.IsSecureConnection))
                URL.Append("s");

            URL.Append("://");
            URL.Append(HttpContext.Current.Request.Url.Host);

            int port = HttpContext.Current.Request.Url.Port;
            if (port != 80 && port != 443)
                URL.Append(":" + port.ToString());

            return URL.ToString();
        }
    }
    public class Utilities
    {
        public const int maxInteger = 2147483647;
        public const int minInteger = -2147483648;
        public static string GenerateRandomKey(int KeyLength = 10)
        {
            int i_key;
            float Random1;
            Int16 arrIndex;
            StringBuilder sb = new StringBuilder();
            string RandomLetter;

            string RandomKey_Letters = "abcdefghijklmnopqrstuvwxyz";
            string RandomKey_Numbers = "0123456789";
            int RandomKey_Chars;
            char[] LettersArray;
            char[] NumbersArray;

            RandomKey_Chars = KeyLength;

            // CONVERT LettersArray & NumbersArray TO CHARACTR ARRAYS
            LettersArray = RandomKey_Letters.ToCharArray();
            NumbersArray = RandomKey_Numbers.ToCharArray();

            for (i_key = 1; i_key <= RandomKey_Chars; i_key++)
            {
                // START THE CLOCK    - LAITH - 27/07/2005 18:01:18 -
                Microsoft.VisualBasic.VBMath.Randomize();
                Random1 = Microsoft.VisualBasic.VBMath.Rnd();
                arrIndex = -1;
                // IF THE VALUE IS AN EVEN NUMBER WE GENERATE A LETTER,
                // OTHERWISE WE GENERATE A NUMBER  
                // - LAITH - 27/07/2005 18:02:55 -
                // THE NUMBER '111' WAS RANDOMLY CHOSEN. ANY NUMBER
                // WILL DO, WE JUST NEED TO BRING THE VALUE
                // ABOVE '0'     - LAITH - 27/07/2005 18:40:48 -
                if ((System.Convert.ToInt32(Random1 * 111)) % 2 == 0)
                {
                    // GENERATE A RANDOM INDEX IN THE LETTERS
                    // CHARACTER ARRAY   - LAITH - 27/07/2005 18:47:44 -
                    while (arrIndex < 0)
                        arrIndex = Convert.ToInt16(LettersArray.GetUpperBound(0) * Random1);
                    RandomLetter = LettersArray[arrIndex].ToString();
                    // CREATE ANOTHER RANDOM NUMBER. IF IT IS ODD,
                    // WE CAPITALIZE THE LETTER
                    // - LAITH - 27/07/2005 18:55:59 -
                    if ((System.Convert.ToInt32(arrIndex * Random1 * 99)) % 2 != 0)
                    {
                        RandomLetter = LettersArray[arrIndex].ToString();
                        RandomLetter = RandomLetter.ToUpper();
                    }
                    sb.Append(RandomLetter);
                }
                else
                {
                    // GENERATE A RANDOM INDEX IN THE NUMBERS
                    // CHARACTER ARRAY   - LAITH - 27/07/2005 18:47:44 -
                    while (arrIndex < 0)
                        arrIndex = Convert.ToInt16(NumbersArray.GetUpperBound(0) * Random1);
                    sb.Append(NumbersArray[arrIndex]);
                }
            }
            return sb.ToString();
        }
        public static string RFC2898_Hash(string StringToHash)
        {
            byte[] salt = System.Text.ASCIIEncoding.ASCII.GetBytes("HBSA Snooker League ");
            int numberOfRounds = 5;
            using (Rfc2898DeriveBytes rfc2898DeriveBytes = new Rfc2898DeriveBytes(Encoding.UTF8.GetBytes(StringToHash), salt, numberOfRounds))
            {
                return Convert.ToBase64String(rfc2898DeriveBytes.GetBytes(32));
            }
        }
        public static string SerialiseDataTable(DataTable dt)
        {
            if (dt.TableName == "")
                dt.TableName = "table";

            System.IO.StringWriter sw = new System.IO.StringWriter();
            try
            {
                dt.WriteXml(sw);
                return sw.ToString().Replace("<", Strings.Chr(2).ToString()).Replace(">", Strings.Chr(3).ToString());
            }
            catch (Exception)
            {
                return null;
            }

        }
        public static DataTable DeSerialiseDataTable(String dataTableAsXMLString)
        {
            DataSet ds = new DataSet();
            System.IO.StringReader sr = new System.IO.StringReader(dataTableAsXMLString.Replace(Strings.Chr(2).ToString(), "<").Replace(Strings.Chr(3).ToString(), ">"));
            try
            {
                ds.ReadXml(sr);
                return ds.Tables[0];
            }
            catch (Exception)
            {
                return new DataTable();
            }
            
        }
        public static DateTime UKDateTimeNow()
        {
            //get the UK date and time of now using UTC time
            DateTime startOfBST;
            DateTime endOfBST;
            DateTime now = DateTime.UtcNow;
            //get 1st and last dates of BST
            startOfBST = new DateTime(now.Year, 3, 31);
            endOfBST = new DateTime(now.Year, 10, 30);
            //get last Sunday of the month 
            while (startOfBST.DayOfWeek != DayOfWeek.Sunday)
                startOfBST = startOfBST.AddDays(-1);
            while (endOfBST.DayOfWeek != DayOfWeek.Sunday)
                endOfBST = endOfBST.AddDays(-1);
            //BST changes at 2am 
            startOfBST = startOfBST.AddHours(2);
            endOfBST = endOfBST.AddHours(2);
            //if in BST add an hour to UTC datetime
            if (now > startOfBST && now < endOfBST)
                now = now.AddHours(1);
            
            return now;
        }
        public static string BuildMobileActiveTable(DataTable table, int startCol = 0,
                                                                     int endCol = -1,
                                                                     string InfoDivID = "" ,
                                                                     string DetailType = "" 
                                                                     )
        {
            //Build a table for use in mobile pages that will use the 1st supplied column
            //as an ID
            if (table.Rows.Count == 0)
                return "No data found for this selection.";
                
            if (endCol == -1)
                endCol = table.Columns.Count - 1;
                        
            // Given a datatable create an HTML table from it.

            // Start the table
            StringBuilder HTML = new StringBuilder("<table>");

            //Build the header row
            HTML.Append("<tr>");
            for (int ix = startCol; ix <= endCol; ix++)
                HTML.Append("<th>" + table.Columns[ix].ColumnName + "</th>");
            HTML.Append("</tr>");

            //Build the data rows
            foreach (DataRow row in table.Rows)
            {
                HTML.Append("<tr");
                if (InfoDivID != "") 
                    HTML.Append(" onmouseover=\"this.style.cursor = 'pointer';\" onclick=\"loadInfoDiv('" + InfoDivID + "','" + row.ItemArray[0].ToString().Replace("'","~") + "','" + DetailType + "');\"");
                HTML.Append(">");

                for (int ix = startCol; ix <= endCol; ix++) 
                    HTML.Append("<td>" + row.ItemArray[ix].ToString() + "</td>");
                HTML.Append("</tr>");
            }
             
            //Finish the table
            HTML.Append("</table>");

            return HTML.ToString();
        }
        public static FileInfo Handbook()
        {
            DirectoryInfo DocumentsFolder = new DirectoryInfo(HttpContext.Current.Server.MapPath("~/Documents/"));
            FileInfo[] files = DocumentsFolder.GetFiles("*handbook*");
            if (files.Length > 0)
                return files[0];
            else
                return null;
        }
        public static bool HandbookExists()
        {
            return (Handbook() != null); 
        }
    }
    public class HBSAencoder
    {   // private HBSA encoder/decoder to keep data non visible to the public+
        public static string Encode(string clearText)
        {
            byte[] clearBytes = Encoding.Unicode.GetBytes(clearText);
            byte[] workBytes = new byte[clearBytes.Length];
            for (int ix = 0; ix < clearBytes.Length; ix += 2)
            {
                BitArray workByte = new BitArray(new byte[] { clearBytes[ix], clearBytes[ix+1] });
                SwapBits(ref workByte, 0, 15);
                SwapBits(ref workByte, 1, 14);
                SwapBits(ref workByte, 2, 13);
                SwapBits(ref workByte, 3, 12);
                SwapBits(ref workByte, 4, 11);
                SwapBits(ref workByte, 5, 10);
                SwapBits(ref workByte, 6, 9);
                SwapBits(ref workByte, 7, 8);
                byte[] newWorkByte = new byte[2];
                workByte.CopyTo(newWorkByte, 0);
                workBytes[ix] = newWorkByte[0];
                workBytes[ix+1] = newWorkByte[1];
            }
            for (int ix = 0; ix < clearBytes.Length-2; ix += 4)
            {
                SwapBytes(ref workBytes, ix, ix + 3);
                SwapBytes(ref workBytes, ix + 1, ix + 2);

            }

            return ToHexString(Encoding.Unicode.GetString(workBytes));
        }
        public static string Decode(string confusedText)
        {
            byte[] confusedBytes = Encoding.Unicode.GetBytes(FromHexString(confusedText));
            byte[] workBytes = new byte[confusedBytes.Length];
            for (int ix = 0; ix < confusedBytes.Length; ix += 2)
            {
                BitArray workByte = new BitArray(new byte[] { confusedBytes[ix], confusedBytes[ix+1] });
                SwapBits(ref workByte, 0, 15);
                SwapBits(ref workByte, 1, 14);
                SwapBits(ref workByte, 2, 13);
                SwapBits(ref workByte, 3, 12);
                SwapBits(ref workByte, 4, 11);
                SwapBits(ref workByte, 5, 10);
                SwapBits(ref workByte, 6, 9);
                SwapBits(ref workByte, 7, 8);
                byte[] newWorkByte = new byte[2];
                workByte.CopyTo(newWorkByte, 0);
                workBytes[ix] = newWorkByte[0];
                workBytes[ix + 1] = newWorkByte[1];
            }
            for (int ix = 0; ix < confusedBytes.Length-2; ix += 4)
            {
                SwapBytes(ref workBytes, ix, ix + 3);
                SwapBytes(ref workBytes, ix + 1, ix + 2);

            }
            return Encoding.Unicode.GetString(workBytes);
        }
        static void SwapBits(ref BitArray workByte, int ix1, int ix2)
        {
            BitArray wk = new BitArray(workByte);

            workByte[ix1] = wk[ix2];
            workByte[ix2] = wk[ix1];
        }
        static void SwapBytes(ref byte[] workByte, int ix1, int ix2)
        {
            byte wk = workByte[ix1];
            workByte[ix1] = workByte[ix2];
            workByte[ix2] = wk;
        }
        static string ToHexString(string str)
        {
            var sb = new StringBuilder();

            var bytes = Encoding.Unicode.GetBytes(str);
            foreach (var t in bytes)
            {
                sb.Append(t.ToString("X2"));
            }

            return sb.ToString();
        }
        static string FromHexString(string hexString)
        {
            var bytes = new byte[hexString.Length / 2];
            for (var i = 0; i < bytes.Length; i++)
            {
                bytes[i] = Convert.ToByte(hexString.Substring(i * 2, 2), 16);
            }

            return Encoding.Unicode.GetString(bytes);
        }

    }
}

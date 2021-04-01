using System;
using System.Collections.Generic;
using System.Collections.Specialized;
using System.IO;
using System.Linq;
using System.Net;
using System.Text;
using System.Threading.Tasks;
using System.Web;

namespace HBSAcodeLibrary
{
    public class PayPalFunctions
    {
        public class NVPAPICaller
        {
            private readonly string host; // = "www.paypal.com"     '"www.sandbox.paypal.com"
            private readonly string pendpointurl; // = "https://api-3t.paypal.com/nvp" '"https://api-3t.sandbox.paypal.com/nvp"

            private readonly string returnURL; // = "" & HBSA_data.SiteRootURL.GetSiteRootUrl() & "/EntryFeePaid.aspx"
            private readonly string cancelURL; // = "" & HBSA_data.SiteRootURL.GetSiteRootUrl() & "/EntryFeeCancelled.aspx"
                                      // Private Const CVV2 As String = "CVV2"

            private readonly string APIUsername; // = "accounts_api1.huddersfieldsnooker.com" '"accountsfacilitator2_api1.huddersfieldsnooker.com"
            private readonly string APIPassword; // = "FTDMJYEWX5YNRC7E" '"KRJ3ZUC7U5HB8Y9J"
            private readonly string APISignature; // = "AFcWxV21C7fd0v3bYYYRCpSSRl31AE7dPMyIgcVhpUVmSkkY9tl61Czg" '"AobES.Ca-Kr9i5a8zBjHh6--ZnkRA3UW41.Kj7NBYoN.w2M7Z1Sk2UVM"
            private readonly string APIVersion = "97";
            private readonly string Subject = "";
            private readonly string BNCode = "PP-ECWizard";

            // HttpWebRequest Timeout specified in milliseconds 
            private readonly int _Timeout = 5000;
            // Private Shared ReadOnly SECURED_NVPS As String() = New String() {ACCT, CVV2, SIGNATURE, PWD}

            public NVPAPICaller()
            {
                using (PayPalCredentials PP = new PayPalCredentials())
                {
                    APIUsername = PP.username;
                    APIPassword = PP.password;
                    APISignature = PP.signature;
                    _Timeout = PP.timeout;
                    pendpointurl = PP.endPointURL;
                    host = PP.host;
                    returnURL = PP.ReturnURL;
                    cancelURL = PP.CancelURL;
                }
            }

            public bool StartExpressCheckout(string amt, int PaymentID, ref string token, ref string retMsg, string Description)
            {
                // If bSandbox Then
                // pendpointurl = "https://api-3t.sandbox.paypal.com/nvp"
                // host = "www.sandbox.paypal.com"
                // End If

                // Dim myURI As New Uri(HttpContext.Current.Request.Url, "/")

                // Dim returnURL As String = myURI.AbsoluteUri & "FeePaidConfirm.aspx"
                // Dim cancelURL As String = myURI.AbsoluteUri & "EntryFeeCancelled.aspx"

                NVPCodec encoder = new NVPCodec
                {
                    ["METHOD"] = "SetExpressCheckout",
                    ["RETURNURL"] = returnURL,
                    ["CANCELURL"] = cancelURL,
                    ["PAYMENTREQUEST_0_AMT"] = amt,
                    ["PAYMENTREQUEST_0_PAYMENTACTION"] = "Sale",
                    ["PAYMENTREQUEST_0_CURRENCYCODE"] = "GBP",
                    // encoder("LOGOIMG") = "https://huddersfieldsnooker.com/images/logo.jpg"
                    ["NOSHIPPING"] = "1", // Do not show shipping address at all
                    ["REQCONFIRMSHIPPING"] = "0",
                    ["ALLOWNOTE"] = "1", // allow user to enter a note
                    ["PAYMENTREQUEST_0_INVNUM"] = System.Convert.ToString(PaymentID),  // use the paypal invoice number to carry our PaymentID "there and back"       
                    ["PAYMENTREQUEST_0_DESC"] = Description
                };

                string pStrrequestforNvp = encoder.Encode();
                string pStresponsenvp = HttpCall(pStrrequestforNvp);


                NVPCodec decoder = new NVPCodec();
                decoder.Decode(pStresponsenvp);

                string strAck = decoder["ACK"];
                if (strAck != null && (strAck.ToLower() == "success" || strAck.ToLower() == "successwithwarning"))
                {
                    token = decoder["TOKEN"];
                    retMsg = ("https://" + host + "/cgi-bin/webscr?cmd=_express-checkout" + "&token=") + token;
                    return true;
                }
                else
                {
                    if (!pStresponsenvp.ToUpper().StartsWith("ERROR"))
                        retMsg = (("ErrorCode=" + decoder["L_ERRORCODE0"] + "&" + "Desc=") + decoder["L_SHORTMESSAGE0"] + "&" + "Desc2=") + decoder["L_LONGMESSAGE0"];
                    else
                        retMsg = "ErrorCode=99999~|~" + pStresponsenvp;
                    return false;
                }
            }

            public bool ConfirmPayment(string finalPaymentAmount, string token, string PayerId, ref NVPCodec decoder, ref string retMsg)
            {
                NVPCodec encoder = new NVPCodec
                {
                    ["METHOD"] = "DoExpressCheckoutPayment",
                    ["TOKEN"] = token,
                    ["PAYMENTREQUEST_0_PAYMENTACTION"] = "Sale",
                    ["PAYERID"] = PayerId,
                    ["PAYMENTREQUEST_0_AMT"] = finalPaymentAmount,
                    ["PAYMENTREQUEST_0_CURRENCYCODE"] = "GBP"
                };

                string pStrrequestforNvp = encoder.Encode();
                string pStresponsenvp = HttpCall(pStrrequestforNvp);

                decoder = new NVPCodec();
                decoder.Decode(pStresponsenvp);

                string strAck = decoder["ACK"] == null ? "fail" : decoder["ACK"].ToLower();
                if (strAck != null && (strAck == "success" || strAck == "successwithwarning"))
                    return true;
                else
                {
                    if (pStresponsenvp.StartsWith("ERROR"))
                        retMsg = ("ErrorCode=99999" + decoder["L_ERRORCODE0"] + "&" + "Desc=") + pStresponsenvp;
                    else
                        retMsg = (("ErrorCode=" + decoder["L_ERRORCODE0"] + "&" + "Desc=") + decoder["L_SHORTMESSAGE0"] + "&" + "Desc2=") + decoder["L_LONGMESSAGE0"];


                    return false;
                }
            }

            public bool GetDetails(string token, ref NVPCodec decoder, ref string retMsg)
            {
                NVPCodec encoder = new NVPCodec
                {
                    ["METHOD"] = "GetExpressCheckoutDetails",
                    ["TOKEN"] = token
                };

                string pStrrequestforNvp = encoder.Encode();
                string pStresponsenvp = HttpCall(pStrrequestforNvp);

                // decoder = New NVPCodec()
                decoder.Decode(pStresponsenvp);

                string strAck = decoder["ACK"].ToLower();
                if (strAck != null && (strAck == "success" || strAck == "successwithwarning"))
                    return true;
                else
                {
                    retMsg = (("ErrorCode=" + decoder["L_ERRORCODE0"] + "&" + "Desc=") + decoder["L_SHORTMESSAGE0"] + "&" + "Desc2=") + decoder["L_LONGMESSAGE0"];

                    return false;
                }
            }


            /// <summary> 
            ///         ''' HttpCall: The main method that is used for all API calls 
            ///         ''' </summary> 
            ///         ''' <param name="NvpRequest"></param> 
            ///         ''' <returns></returns>
            public string HttpCall(string NvpRequest)
            {

                // CallNvpServer 

                string url = pendpointurl;

                // To Add the credentials from the profile
                //NVPCodec codec = new NVPCodec();
                string strPost = (NvpRequest + "&") + BuildCredentialsNVPString();
                strPost = (strPost + "&BUTTONSOURCE=") + HttpUtility.UrlEncode(BNCode);

                HttpWebRequest objRequest = (HttpWebRequest)WebRequest.Create(url);
                objRequest.ProtocolVersion = HttpVersion.Version11;
                objRequest.Timeout = _Timeout;
                objRequest.Method = "POST";
                objRequest.ContentLength = strPost.Length;

                string result;

                try
                {
                    System.Net.ServicePointManager.SecurityProtocol = System.Net.SecurityProtocolType.Tls12;

                    using (StreamWriter myWriter = new StreamWriter(objRequest.GetRequestStream()))
                    {
                        myWriter.Write(strPost);
                    }

                    // Retrieve the Response returned from the NVP API call to PayPal 
                    HttpWebResponse objResponse = (HttpWebResponse)objRequest.GetResponse();

                    using (StreamReader sr = new StreamReader(objResponse.GetResponseStream()))
                    {
                        result = sr.ReadToEnd();
                    }
                }
                catch (Exception e)
                {
                    string msg = e.Message;
                    Exception ex = e.InnerException;
                    while (ex != null)
                    {
                        msg += "~|~" + ex.Message;
                        ex = ex.InnerException;
                    }

                    result = ("ERROR calling PayPal API:~|~" + msg);
                }

                return result;
            }

            /// <summary> 
            ///         ''' Credentials added to the NVP string 
            ///         ''' </summary>
            ///         ''' <returns></returns>
            private string BuildCredentialsNVPString()
            {
                NVPCodec codec = new NVPCodec();

                if (!IsEmpty(APIUsername))
                    codec["USER"] = APIUsername;

                if (!IsEmpty(APIPassword))
                    codec["PWD"] = APIPassword;

                if (!IsEmpty(APISignature))
                    codec["SIGNATURE"] = APISignature;

                if (!IsEmpty(Subject))
                    codec["SUBJECT"] = Subject;

                codec["VERSION"] = APIVersion;

                return codec.Encode();
            }

            /// <summary> 
            ///         ''' Returns if a string is empty or null 
            ///         ''' </summary> 
            ///         ''' <param name="s">the string</param> 
            ///         ''' <returns>true if the string is not null and is not empty or just whitespace</returns>
            public static bool IsEmpty(string s)
            {
                return s == null || s.Trim() == string.Empty;
            }
        }
        public sealed class NVPCodec : NameValueCollection
        {
            private const string AMPERSAND = "&";
            private const string EQUALSIGN = "=";
            private static readonly char[] AMPERSAND_CHAR_ARRAY = AMPERSAND.ToCharArray();
            private static readonly char[] EQUALS_CHAR_ARRAY = EQUALSIGN.ToCharArray();

            /// <summary> 
            ///         ''' Returns the built NVP string of all name/value pairs in the Hashtable 
            ///         ''' </summary> 
            ///         ''' <returns></returns>
            public string Encode()
            {
                StringBuilder sb = new StringBuilder();
                bool firstPair = true;
                foreach (string kv in AllKeys)
                {
                    string name = UrlEncode(kv);
                    string value = UrlEncode(this[kv]);
                    if (!firstPair)
                        sb.Append(AMPERSAND);
                    sb.Append(name).Append(EQUALSIGN).Append(value);
                    firstPair = false;
                }
                return sb.ToString();
            }

            /// <summary> 
            ///         ''' Decoding the string 
            ///         ''' </summary> 
            ///         ''' <param name="nvpstring"></param>
            public void Decode(string nvpstring)
            {
                Clear();
                foreach (string nvp in nvpstring.Split(AMPERSAND_CHAR_ARRAY))
                {
                    string[] tokens = nvp.Split(EQUALS_CHAR_ARRAY);
                    if (tokens.Length >= 2)
                    {
                        string name = UrlDecode(tokens[0]);
                        string value = UrlDecode(tokens[1]);
                        Add(name, value);
                    }
                }
            }

            private static string UrlDecode(string s)
            {
                return HttpUtility.UrlDecode(s);
            }
            private static string UrlEncode(string s)
            {
                return HttpUtility.UrlEncode(s);
            }

            public void Add(string name, string value, int index)
            {
                this.Add(GetArrayName(index, name), value);
            }

            public void Remove(string arrayName, int index)
            {
                this.Remove(GetArrayName(index, arrayName));
            }

            /// <summary> 
            ///         ''' 
            ///         ''' </summary>
            public string this[string name, int index]
            {
                get
                {
                    return this[GetArrayName(index, name)];
                }
                set
                {
                    this[GetArrayName(index, name)] = value;
                }
            }

            private static string GetArrayName(int index, string name)
            {
                if (index < 0)
                    throw new ArgumentOutOfRangeException("index", "index can not be negative : " + index);
                return name + index;
            }
        }

    }
}

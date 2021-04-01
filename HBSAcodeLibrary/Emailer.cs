using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data.SqlClient;
using System.Data;

namespace HBSAcodeLibrary
{
    public class Emailer
    {
        public static void Send_eMail(string toAddress, string subject, string body, string ccAddress = "", string ReplyTo = "", int MatchResultID = 0, string UserID = "")
        {
            string Footer = "<br/><br/><i>Please do not reply to this email because it sent from an automatic sender, and the mail box is not monitored.<br>" + 
                            "If you wish to contact the league please use the web site and go to the contact page, or <a href='" + 
                            HBSAcodeLibrary.SiteRootURL.GetSiteRootUrl() + "/Contact.aspx'> click here </a>.</i><br/><br/>" + 
                            "<strong>Huddersfield Billiards and Snooker Web Site</strong>";
            char[] semiColon = { ';' };

            using (HBSAcodeLibrary.HBSA_Configuration cfg = new HBSAcodeLibrary.HBSA_Configuration())
            {
                using (System.Net.Mail.MailMessage message = new System.Net.Mail.MailMessage())
                {

                    // set up the message
                    message.From = new System.Net.Mail.MailAddress(cfg.Value("WebFromAddress"), "HBSA Website");

                    string[] addressList = new string[0];
                    int ix;

                    // set the list of recipients
                    foreach (string address in toAddress.Split(semiColon))
                        AddressList_Add(ref addressList, address);
                    for (ix = 0; ix <= addressList.Count() - 1; ix++)
                        message.To.Add(addressList[ix]);

                    // set the list of cc addresses
                    if (ccAddress != "")
                    {
                        foreach (string address in ccAddress.Split(semiColon))
                            AddressList_Add(ref addressList, address);
                    }
                    AddressList_Add(ref addressList, cfg.Value("WebAdministratorEmail"));
                    for (int iy = ix; iy <= addressList.Count() - 1; iy++)
                        message.CC.Add(addressList[iy]);

                    // set the reply address if needed
                    if (IsValidEmailAddress(ReplyTo))
                    {
                        if (ReplyTo != "")
                            message.ReplyToList.Add(ReplyTo.Replace(";", ","));
                    }

                    message.IsBodyHtml = true;
                    message.Body = body + Footer;
                    message.Subject = subject;

                    // setup the SMTP client
                    System.Net.Mail.SmtpClient smtp = new System.Net.Mail.SmtpClient(cfg.Value("SMTPServer"), System.Convert.ToInt32(cfg.Value("SMTPport")))
                    {
                        Credentials = new System.Net.NetworkCredential(cfg.Value("SMTPServerUsername"), cfg.Value("SMTPServerPassword")),
                        EnableSsl = System.Convert.ToBoolean(cfg.Value("SMTPssl")),
                        DeliveryMethod = System.Net.Mail.SmtpDeliveryMethod.Network
                    };

                    if (!EmailIsDuplicate(message, Footer))
                    {

                        // store the email
                        StoreTheEmail(message, MatchResultID, Footer, UserID, smtp);

                        if (!HttpContext.Current.Request.Url.Authority.ToLower().Contains("test") && !HttpContext.Current.Request.Url.Authority.ToLower().Contains("localhost"))
                        {
                            try
                            {
                                smtp.Send(message);
                            }
                            catch (Exception ex)
                            {
                                message.Body = "ERROR OCCURRED sending this: " + ex.Message + "<hr/>" + message.Body;
                                throw new Exception(ex.Message, ex);
                            }
                        }
                    }

                    smtp.Dispose();
                }
            }
        }
        public static void AddressList_Add(ref string[] AddressList, string address)
        {

            // only add another address if it is not already in

            if (IsValidEmailAddress(address))
            {
                foreach (string addr in AddressList)
                {
                    if (address == addr)
                        return;
                }

                if (address != "")
                {
                    var oldAddressList = AddressList;
                    AddressList = new string[AddressList.Length + 1];
                    if (oldAddressList != null)
                        Array.Copy(oldAddressList, AddressList, Math.Min(AddressList.Length + 1, oldAddressList.Length));
                    AddressList[AddressList.Length - 1] = address;
                }
            }
        }
        public static bool IsValidEmailAddress(string email)
        {
            try
            {
                System.Net.Mail.MailAddress m = new System.Net.Mail.MailAddress(email);
                return true;
            }
            catch (Exception)
            {
                return false;
            }
        }
        public static void LogEmailfailure(string emailAddresses, string Detail, string emailType)
        {
            HBSAcodeLibrary.ActivityLog.LogActivity("Send " + emailType + " email to " + emailAddresses + " failure.", 0, Detail);

            try
            {
                using (HBSAcodeLibrary.HBSA_Configuration cfg = new HBSAcodeLibrary.HBSA_Configuration())
                {
                    Send_eMail(cfg.Value("WebFromAddress"), "Email failure", "Check Activity log for email failure");
                }
            }
            catch (Exception)
            { //ignore exceptions as we're only logging a previous error }
            }

        }
        public static void StoreTheEmail(System.Net.Mail.MailMessage Message, int MatchResultID, string Footer, string UserID, System.Net.Mail.SmtpClient smtp)
        {
            List<SqlParameter> parameters = new List<SqlParameter>()
            {
                new SqlParameter("Sender", Message.From.Address),
                new SqlParameter("ReplyTo", AddressList(Message.ReplyToList)),
                new SqlParameter("ToAddresses", AddressList(Message.To)),
                new SqlParameter("CCAddresses", AddressList(Message.CC)),
                new SqlParameter("BCCAddresses", AddressList(Message.Bcc)),
                new SqlParameter("Subject", Message.Subject),
                new SqlParameter("Body", Message.Body.Replace(Footer, "")),
                new SqlParameter("MatchResultID", MatchResultID),
                new SqlParameter("UserID", UserID),
                new SqlParameter("SMTPServer", smtp.Host),
                new SqlParameter("SMTPPort", smtp.Port),
        };

            try { SQLcommands.ExecNonQuery("insertEMailLog", parameters); }
            catch (Exception) { };
        }
        public static string AddressList(System.Net.Mail.MailAddressCollection AddressCollection)
        {
            string addresses = "";
            foreach (System.Net.Mail.MailAddress address in AddressCollection)
                addresses += address.Address + ";";

            return addresses;
        }
        public static bool EmailIsDuplicate(System.Net.Mail.MailMessage Message, string Footer)
        {
            string addressees = "";
            foreach (System.Net.Mail.MailAddress address in Message.To)
                addressees += address.Address + ";";
            if (addressees.Length < 1)
                return false;
            else
                addressees = addressees.Substring(0, addressees.Length - 1);
            
            List<SqlParameter> parameters = new List<SqlParameter>()
            {
                new SqlParameter("Sender", Message.From.Address),
                new SqlParameter("ToAddresses", addressees),
                new SqlParameter("Subject", Message.Subject),
                new SqlParameter("Body", Message.Body.Replace(Footer, ""))
            };

            string result = SQLcommands.ExecScalar("CheckForDuplicateEmail", parameters).ToString();

            return HBSA_Configuration.ConvertConfigurationValueToBoolean(result);
        }
        public static string SendHandicapChangeEmail(string ClubEmail, string TeamEMail, 
                                                     string PlayerEmail, string PlayerName, string TeamName, 
                                                     string OldHandicap, string NewHandicap, string SectionName)        // League name + SectionName
            {
                string SendHandicapChangeEmailResult = "";

                string BodyTemplate;
            using (EmailTemplateData emailTemplate = new EmailTemplateData("handicapChange"))
            {
                BodyTemplate = emailTemplate.eMailTemplateHTML;
            }

                // send email
                using (HBSAcodeLibrary.HBSA_Configuration cfg = new HBSAcodeLibrary.HBSA_Configuration())
                {
                    string toAddress = cfg.Value("LeagueSecretaryEmail");

                    if (cfg.Value("HandicapChangeEmail") != "")
                        toAddress += ";" + cfg.Value("HandicapChangeEmail");

                    try
                    {
                        if (ClubEmail.Trim() != "")
                            toAddress += ";" + ClubEmail.Trim();
                        if (TeamEMail.Trim() != "")
                            toAddress += ";" + TeamEMail.Trim();
                    }
                    catch { }

                if (PlayerEmail.Trim() != "")
                        toAddress += ";" + PlayerEmail.Trim();

                    string subject = "*** Web site handicap change alert ***";
                    string body = BodyTemplate.Replace("|Team|", TeamName)
                                              .Replace("|Date|", DateTime.Today.ToLongDateString())
                                              .Replace("|Player|", PlayerName)
                                              .Replace("|old handicap|", OldHandicap)
                                              .Replace("|new handicap|", NewHandicap)
                                              .Replace("|Section|", SectionName);

                    try
                    {
                        Emailer.Send_eMail(toAddress, subject, body);       // 334
                    }
                    catch (Exception eMex)
                    {
                        string err = "Team:|Team|, Player:|Player|, new handicap:|new handicap|, Section:|Section|.";
                        err = err.Replace("|Team|", TeamName).Replace("|Date|", DateTime.Today.ToLongDateString()).Replace("|Player|", PlayerName).Replace("|new handicap|", NewHandicap).Replace("|Section|", SectionName) + Microsoft.VisualBasic.Constants.vbCrLf + eMex.Message;
                        SendHandicapChangeEmailResult += "<br/><font color=red><strong>Error sending an email:<br/>" + err.Replace(Microsoft.VisualBasic.Constants.vbCrLf, "<br/>") + ".</font>";
                        Emailer.LogEmailfailure(toAddress, err, "handicap change");
                    }
                }
                return SendHandicapChangeEmailResult;
           }
        public static string SendFineImposedEmail(string EmailAddressList, 
                                                  string ClubName, string Offence, string Comment, 
                                                  decimal Amount)
        {
            string BodyTemplate;
            using (EmailTemplateData emailTemplate = new EmailTemplateData("fineImposed"))
            {
                BodyTemplate = emailTemplate.eMailTemplateHTML;
            }

            string SendFineImposedEmailResult = "";

            // send email
            using (HBSAcodeLibrary.HBSA_Configuration cfg = new HBSAcodeLibrary.HBSA_Configuration())
            {
                string toAddress = cfg.Value("LeagueSecretaryEmail");
                toAddress += ";" + cfg.Value("TreasurerEmail");
                toAddress += ";" + EmailAddressList;

                string subject = "*** Fine imposed alert ***";
                string body;
                using (ContentData InfoPage = new ContentData("Payments"))
                {
                    DateTime payByDate = new DateTime();
                    payByDate = DateTime.Today;
                    payByDate = payByDate.AddDays(60);

                    body = BodyTemplate.Replace("|Club Name|", ClubName)
                                       .Replace("|Date|", DateTime.Today.ToLongDateString())
                                       .Replace("|PayByDate|", payByDate.ToLongDateString())
                                       .Replace("|Offence|", Offence)
                                       .Replace("|Comment|", Comment)
                                       .Replace("|Amount|", Amount.ToString("0.00"))
                                       .Replace("|Payment Clause|", InfoPage.ContentHTML);
                }

                try
                {
                    Emailer.Send_eMail(toAddress, subject, body);
                }
                catch (Exception)
                {
                    string err = "Error sending fine imposed email. " + DateTime.Today.ToLongDateString() + " to " + ClubName +
                                 " for " + Offence + " " + Comment + " " + Amount.ToString("C", System.Globalization.CultureInfo.GetCultureInfo("en-GB"));
                    SendFineImposedEmailResult += "<br/>" + err.Replace(Microsoft.VisualBasic.Constants.vbCrLf, "<br/>") + ".</font>";
                    Emailer.LogEmailfailure(toAddress, err, "impose fine");
                }
            }
            return SendFineImposedEmailResult;
        }
        public static DataTable Get_eMailList (DateTime startDate, DateTime endDate, string subjectFilter)
        {
            return SQLcommands.ExecDataTable("Get_eMailList", new List<SqlParameter> 
                                                              {    new SqlParameter("StartDate",startDate),
                                                                   new SqlParameter("EndDate", endDate),
                                                                   new SqlParameter("SubjectFilter",subjectFilter) });
        }
    }
}

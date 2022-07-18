using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data.SqlClient;
using System.Data;
using System.IO;

namespace HBSAcodeLibrary
{
    public class Emailer
    {
        public static void Send_eMail(string toAddress, string subject, string Body, 
                                      string ccAddress = "", string ReplyTo = "", int MatchResultID = 0, 
                                      string UserID = "", bool TestOnly = false)
        {
            string Footer = "<br/><br/><i>Please do not reply to this email because it sent from an automatic sender, and the mail box is not monitored.<br>" +
                            "If you wish to contact the league please use the web site and go to the contact page, or <a href='" +
                            HBSAcodeLibrary.SiteRootURL.GetSiteRootUrl() + "/Contact.aspx'> click here </a>.</i><br/><br/>" +
                            "<strong>Huddersfield Billiards and Snooker Web Site</strong>";
            char[] semiColon = { ';' };

            using (HBSAcodeLibrary.HBSA_Configuration cfg = new HBSAcodeLibrary.HBSA_Configuration())
            {
                MimeKit.MimeMessage MimeMessage = new MimeKit.MimeMessage();

                // set up the sender(s)
                MimeMessage.From.Add(new MimeKit.MailboxAddress("HBSA Website", cfg.Value("WebFromAddress")));

                List<string> addressList = new List<string>();
                int ix;

                // set the list of recipients
                foreach (string address in toAddress.Split(semiColon))
                    AddressList_Add(ref addressList, address);
                for (ix = 0; ix <= addressList.Count() - 1; ix++)
                    MimeMessage.To.Add(new MimeKit.MailboxAddress("", addressList[ix]));

                // set the list of cc addresses
                if (ccAddress != "")
                {
                    foreach (string address in ccAddress.Split(semiColon))
                        AddressList_Add(ref addressList, address);
                    for (int iy = ix; iy <= addressList.Count() - 1; iy++)
                        MimeMessage.Cc.Add(new MimeKit.MailboxAddress("", addressList[iy]));
                }

                // set the reply address if needed
                if (IsValidEmailAddress(ReplyTo))
                    if (ReplyTo != "")
                        MimeMessage.ReplyTo.Add(new MimeKit.MailboxAddress("", ReplyTo.Replace(";", ",")));

                // set the message
                MimeMessage.Body = new MimeKit.TextPart("html") { Text = Body + Footer };
                MimeMessage.Subject = subject;

                if (! EmailIsDuplicate(MimeMessage, Body, Footer))
                {
                    if (HttpContext.Current.Request.Url.Authority.ToLower().Contains("test")
                     || HttpContext.Current.Request.Url.Authority.ToLower().Contains("localhost")
                     || TestOnly)
                    {  // Only store the message when testing
                        StoreTheEmail(MimeMessage, Body, MatchResultID, Footer, UserID, cfg.Value("SMTPServer"), cfg.Value("SMTPport"));
                    }
                    else
                    {
                        try
                        {
                            using (MailKit.Net.Smtp.SmtpClient smtpClient = new MailKit.Net.Smtp.SmtpClient())
                            {   
                                smtpClient.Connect(cfg.Value("SMTPServer"),
                                                   System.Convert.ToInt32(cfg.Value("SMTPport")),
                                                   System.Convert.ToBoolean(cfg.Value("SMTPssl")));
                                smtpClient.Authenticate(cfg.Value("SMTPServerUsername"), cfg.Value("SMTPServerPassword"));
                                smtpClient.Send(MimeMessage);
                                smtpClient.Disconnect(true);
                                // store the email
                                StoreTheEmail(MimeMessage, Body, MatchResultID, Footer, UserID, cfg.Value("SMTPServer"), cfg.Value("SMTPport"));
                            }
                        }
                        catch (Exception ex)
                        {
                            MimeMessage.Subject = "***** ERROR OCCURRED sending this eMail: " + ex.Message + "<hr/>" + MimeMessage.Subject;
                            // store the email
                            StoreTheEmail(MimeMessage, Body, MatchResultID, Footer, UserID, cfg.Value("SMTPServer"), cfg.Value("SMTPport"));

                            throw;
                        }
                    }
                }
            }
        }
        public static void AddressList_Add(ref List<string> AddressList, string address)
        {

            // only add another address if it is not already in

            if (IsValidEmailAddress(address))
            {
                foreach (string addr in AddressList)
                    if (address == addr)
                        return;

                if (address != "")
                    AddressList.Add(address);
            }
        }
        public static bool IsValidEmailAddress(string email)
        {
            try
            {
                MimeKit.MailboxAddress m = new MimeKit.MailboxAddress("", email);
                return true;
            }
            catch (Exception)
            {
                return false;
            }
        }
        //public static void LogEmailfailure(string emailAddresses, string Detail, string emailType)
        //{
        //    HBSAcodeLibrary.ActivityLog.LogActivity("Send " + emailType + " email to " + emailAddresses + " failure.", 0, Detail);

        //    try
        //    {
        //        using (HBSAcodeLibrary.HBSA_Configuration cfg = new HBSAcodeLibrary.HBSA_Configuration())
        //        {
        //            Send_eMail(cfg.Value("WebFromAddress"), "Email failure", "Check Activity log for email failure");
        //        }
        //    }
        //    catch (Exception)
        //    { //ignore exceptions as we're only logging a previous error }
        //    }

        //}
        public static void StoreTheEmail(MimeKit.MimeMessage MimeMessage, string Body, int MatchResultID, string Footer, string UserID, string SMTPHost, string SMTPPort)
        {
            var parameters = new List<SqlParameter>()
            {
                new SqlParameter("Sender",AddressList(MimeMessage.From)),
                new SqlParameter("ReplyTo", AddressList(MimeMessage.ReplyTo)),
                new SqlParameter("ToAddresses", AddressList(MimeMessage.To)),
                new SqlParameter("CCAddresses", AddressList(MimeMessage.Cc)),
                new SqlParameter("BCCAddresses", AddressList(MimeMessage.Bcc)),
                new SqlParameter("Subject", MimeMessage.Subject),
                new SqlParameter("Body", Body.Replace(Footer, "")),
                new SqlParameter("MatchResultID", MatchResultID),
                new SqlParameter("UserID", UserID),
                new SqlParameter("SMTPServer", SMTPHost),
                new SqlParameter("SMTPPort", SMTPPort),
            };

            try { SQLcommands.ExecNonQuery("insertEMailLog", parameters); }
            catch (Exception) { };
        }
        public static string AddressList(MimeKit.InternetAddressList AddressCollection)
        {
            string addresses = "";
            foreach (MimeKit.InternetAddress address in AddressCollection)
                addresses += address.ToString() + ";";
            if (addresses.Length < 1)
                return "";
            else
                return addresses.Substring(0, addresses.Length - 1);
        }
        public static bool EmailIsDuplicate(MimeKit.MimeMessage MimeMessage, string Body, string Footer)
        {
            string addressees = "";
            foreach (MimeKit.InternetAddress address in MimeMessage.To)
                addressees += address.ToString() + ";";

            if (addressees.Length < 1)
                return false;
            else
                addressees = addressees.Substring(0, addressees.Length - 1);

            List<SqlParameter> parameters = new List<SqlParameter>()
            {
                new SqlParameter("Sender",AddressList(MimeMessage.From)),
                new SqlParameter("ToAddresses", AddressList(MimeMessage.To)),
                new SqlParameter("Subject", MimeMessage.Subject),
                new SqlParameter("Body", Body.Replace(Footer, ""))
            };

            string result = SQLcommands.ExecScalar("CheckForDuplicateEmail", parameters).ToString();

            return HBSA_Configuration.ConvertConfigurationValueToBoolean(result);
        }
        private static string GetMimeMessageContent(MimeKit.MimeMessage msg)
        {
            //Get rid of MIME header(s)  these are bound by CrLf's (\r\n)

            string Content = msg.Body.ToString();
            int ix = 0;
            while (Content.StartsWith("\r\n"))
            {
                Content = Content.Substring(2);

                ix = Content.IndexOf("\r\n", 0);
                if (ix != -1)
                    Content = Content.Substring(ix + 2);
            }
            return Content;
        }
        public static string SendPlayerMaintenanceEmail(string MaintenanceType,string Deregistered,
                                                        string ClubEmail, string TeamEMail,
                                                        string PlayerEmail, string PlayerName, string TeamName,
                                                        string OldHandicap, string Handicap, string SectionName)        // League name + SectionName
        {
            string SendPlayerMaintenanceEmailResult = "";

            string BodyTemplate;
            using (EmailTemplateData emailTemplate = new EmailTemplateData(MaintenanceType))
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

                string subject;
                if (MaintenanceType.ToLower().Contains("handicap"))
                    subject = "Handicap change alert.";
                else
                    subject = "Player " + Deregistered + " Registration alert.";

                string body = BodyTemplate.Replace("|Team|", TeamName)
                                          .Replace("|Date|", DateTime.Today.ToLongDateString())
                                          .Replace("|Player|", PlayerName)
                                          .Replace("|De-|", Deregistered)
                                          .Replace("|old handicap|", OldHandicap)
                                          .Replace("|new handicap|", Handicap)
                                          .Replace("|handicap|", Handicap)
                                          .Replace("|Section|", SectionName);

                try
                {
                    Emailer.Send_eMail(toAddress, subject, body);       // 334
                }
                catch (Exception eMex)
                {
                    string err = "Team:|Team|, Player:|Player|, new handicap:|new handicap|, Section:|Section|.";
                    err = err.Replace("|Team|", TeamName).Replace("|Date|", DateTime.Today.ToLongDateString()).Replace("|Player|", PlayerName).Replace("|new handicap|", Handicap).Replace("|Section|", SectionName) + Microsoft.VisualBasic.Constants.vbCrLf + eMex.Message;
                    SendPlayerMaintenanceEmailResult += "<br/><font color=red><strong>Error sending an email:<br/>" + err.Replace(Microsoft.VisualBasic.Constants.vbCrLf, "<br/>") + ".</strong></font>";
                }
            }
            return SendPlayerMaintenanceEmailResult;
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

                string subject = "Fine imposed alert";
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
                }
            }
            return SendFineImposedEmailResult;
        }
        public static string SendPointsAdjustmentEmail(string eMailList, string AddedDeducted, string Adjustment,
                                                       string Team, string Section, string Reason, string action )
        {
            string SendPointsAdjustEmailResult = "";
            string BodyTemplate;

            using (EmailTemplateData emailTemplate = new EmailTemplateData("PointsAdjustment"))
            {
                BodyTemplate = emailTemplate.eMailTemplateHTML;
            }
            // send email
            using (HBSAcodeLibrary.HBSA_Configuration cfg = new HBSAcodeLibrary.HBSA_Configuration())
            {
                string toAddress = cfg.Value("LeagueSecretaryEmail");
                toAddress += ";" + eMailList;

                string subject = "Points adjustment alert";
                string body = BodyTemplate.Replace("|Date|", DateTime.Today.ToLongDateString())
                                           .Replace("|Team|", Team)
                                           .Replace("|Section|", Section)
                                           .Replace("|DownUp|", AddedDeducted)
                                           .Replace("|Adjustment|", Adjustment)
                                           .Replace("|Reason|", Reason)
                                           .Replace("|Action|", action);

                try
                {
                    Emailer.Send_eMail(toAddress, subject, body);
                }
                catch (Exception ex)
                {
                    string err = "Error sending points adjustment email: " + 
                        ex.Message + ". " +
                        DateTime.Today.ToLongDateString() + " to " + toAddress;
                    SendPointsAdjustEmailResult += "<br/>" + err.Replace(Microsoft.VisualBasic.Constants.vbCrLf, "<br/>");
                }
            }
            return SendPointsAdjustEmailResult;
        }
        public static DataTable Get_eMailList(DateTime startDate, DateTime endDate, string subjectFilter)
        {
            return SQLcommands.ExecDataTable("Get_eMailList", new List<SqlParameter>
                                                              {    new SqlParameter("StartDate",startDate),
                                                                   new SqlParameter("EndDate", endDate),
                                                                   new SqlParameter("SubjectFilter",subjectFilter) });
        }
    }
}

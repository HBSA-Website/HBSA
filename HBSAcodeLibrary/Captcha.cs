using System;
using System.Drawing;
using System.Drawing.Imaging;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace HBSAcodeLibrary
{
    public class Captcha
    {
        public static string SetCaptchaImage(ref System.Web.UI.HtmlControls.HtmlImage captcha_Image, 
                                             ref System.Web.UI.WebControls.TextBox captcha_textBox)
        {
            // create object of Bitmap Class and set its width and height.
            Bitmap captchaBitMap = new Bitmap(160, 40);

            // Create Graphics object and assign bitmap object to graphics' object.
            Graphics captchaGraphics = Graphics.FromImage(captchaBitMap);

            //set bitmap attributes
            captchaGraphics.Clear(Color.DarkGreen);
            captchaGraphics.TextRenderingHint = System.Drawing.Text.TextRenderingHint.AntiAlias;
            Font captchaFont = new Font("arial", 20, FontStyle.Regular);
            string captchaString = GenerateCaptchaString();
            captchaGraphics.DrawString(captchaString, captchaFont, Brushes.Yellow, 2, 2);

            //convert the image to a string for the image source
            System.IO.MemoryStream stream = new System.IO.MemoryStream(); 
            captchaBitMap.Save(stream, System.Drawing.Imaging.ImageFormat.Bmp);
            byte[] imageBytes = stream.ToArray();

            // Set the captcha image
            captcha_Image.Src = "data:image/GIF;base64," + Convert.ToBase64String(imageBytes);
            // set captcha textbiox attributes & clear text
            captcha_textBox.Attributes.Add("autocomplete", "off");
            captcha_textBox.Attributes.Add("AutoCompleteType", "Disabled");
            captcha_textBox.Text = "";

            return captchaString;
        }
        private static string GenerateCaptchaString()
        {
            // Below code describes how to create a random string. Some of the digits and letters
            // are ommited because they look same like "i","o","1","0","I","O".
            string[] allowedChar = { "a", "b", "c", "d", "e", "f", "g", "h", "j", "k", "m", "n", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z",
                                     "A","B","C","D","E","F","G","H","J","K","L","M","N","P","Q","R","S","T","U","V","W","X","Y","Z",
                                     "2","3","4","5","6","7","8","9" };
            string CaptchaString = "";
            Random rand = new Random();
            int StrLen = rand.Next(4, 8);
            for (int i = 0; i <= StrLen; i++)
                CaptchaString += allowedChar[rand.Next(0, allowedChar.Length)];

            return CaptchaString; 
        }
    }
}

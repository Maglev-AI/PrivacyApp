import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class PrivacyPolicy extends StatefulWidget {
  const PrivacyPolicy({Key? key}) : super(key: key);

  @override
  State<PrivacyPolicy> createState() => _PrivacyPolicyState();
}

class _PrivacyPolicyState extends State<PrivacyPolicy> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Privacy Policy'),
          elevation: 0,
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.black,
          systemOverlayStyle: SystemUiOverlayStyle.dark,
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: Get.width * 0.05),
          child: ListView(
            children: [
              SizedBox(
                height: Get.height * 0.02,
              ),
              Text(
                '1. Overview',
                style: TextStyle(
                  fontSize: Get.width * 0.05,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: Get.height * 0.01,
              ),
              const Text(
                  'At Maglev AI, accessible from https://www.maglevai.com, one of our main priorities is the privacy of our visitors. This Privacy Policy document contains types of information that is collected and recorded by Maglev AI and how we use it. If you have additional questions or require more information about our Privacy Policy, do not hesitate to contact us.This Privacy Policy applies only to our online activities and is valid for visitors to our website with regards to the information that they shared and/or collect in Maglev AI. This policy is not applicable to any information collected offline or via channels other than this website.'),
              SizedBox(
                height: Get.height * 0.05,
              ),
              Text(
                '2. Consent',
                style: TextStyle(
                  fontSize: Get.width * 0.05,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: Get.height * 0.01,
              ),
              const Text(
                  'By using our website, you hereby consent to our Privacy Policy and agree to its terms.'),
              SizedBox(
                height: Get.height * 0.05,
              ),
              Text(
                '3. Information We Collect',
                style: TextStyle(
                  fontSize: Get.width * 0.05,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: Get.height * 0.01,
              ),
              const Text(
                  'We do not own any data, information or material (collectively, "Content") that you submit on the Services in the course of using the Service. You shall have sole responsibility for the accuracy, quality, integrity, legality, reliability, appropriateness, and intellectual property ownership or right to use of all submitted Content. We may monitor and review the Content on the Services submitted or created using our Services by you. You grant us permission to access, copy, distribute, store, transmit, reformat, display and perform the Content of your user account solely as required for the purpose of providing the Services to you. Without limiting any of those representations or warranties, we have the right, though not the obligation, to, in our own sole discretion, refuse or remove any Content that, in our reasonable opinion, violates any of our policies or is in any way harmful or objectionable. You also grant us the license to use, reproduce, adapt, modify, publish or distribute the Content created by you or stored in your user account for commercial, marketing or any similar purpose.'),
              SizedBox(
                height: Get.height * 0.05,
              ),
              Text(
                '4. How We Use Your Information',
                style: TextStyle(
                  fontSize: Get.width * 0.05,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: Get.height * 0.01,
              ),
              const Text(
                  'We perform regular backups of the Website and its Content and will do our best to ensure completeness and accuracy of these backups. In the event of the hardware failure or data loss we will restore backups automatically to minimize the impact and downtime.'),
              SizedBox(
                height: Get.height * 0.05,
              ),
              Text(
                '5. Log Files',
                style: TextStyle(
                  fontSize: Get.width * 0.05,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: Get.height * 0.01,
              ),
              const Text(
                  'Although the Services may link to other resources (such as websites, mobile applications, etc.), we are not, directly or indirectly, implying any approval, association, sponsorship, endorsement, or affiliation with any linked resource, unless specifically stated herein. Some of the links on the Services may be "affiliate links". This means if you click on the link and purchase an item, the Operator will receive an affiliate commission. We are not responsible for examining or evaluating, and we do not warrant the offerings of, any businesses or individuals or the content of their resources. We do not assume any responsibility or liability for the actions, products, services, and content of any other third parties. You should carefully review the legal statements and other conditions of use of any resource which you access through a link on the Services. Your linking to any other off-site resources is at your own risk.'),
              SizedBox(
                height: Get.height * 0.05,
              ),
              Text(
                '6. Cookies and Web Beacons',
                style: TextStyle(
                  fontSize: Get.width * 0.05,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: Get.height * 0.01,
              ),
              const Text(
                  'In addition to other terms as set forth in the Agreement, you are prohibited from using the Services or Content: (a) for any unlawful purpose; (b) to solicit others to perform or participate in any unlawful acts; (c) to violate any international, federal, provincial or state regulations, rules, laws, or local ordinances; (d) to infringe upon or violate our intellectual property rights or the intellectual property rights of others; (e) to harass, abuse, insult, harm, defame, slander, disparage, intimidate, or discriminate based on gender, sexual orientation, religion, ethnicity, race, age, national origin, or disability; (f) to submit false or misleading information; (g) to upload or transmit viruses or any other type of malicious code that will or may be used in any way that will affect the functionality or operation of the Services, third party products and services, or the Internet; (h) to spam, phish, pharm, pretext, spider, crawl, or scrape; (i) for any obscene or immoral purpose; or (j) to interfere with or circumvent the security features of the Services, third party products and services, or the Internet. We reserve the right to terminate your use of the Services for violating any of the prohibited uses.'),
              SizedBox(
                height: Get.height * 0.05,
              ),
              Text(
                '7. Advertising Partners Privacy Policies',
                style: TextStyle(
                  fontSize: Get.width * 0.05,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: Get.height * 0.01,
              ),
              const Text(
                  '"Intellectual Property Rights" means all present and future rights conferred by statute, common law or equity in or in relation to any copyright and related rights, trademarks, designs, patents, inventions, goodwill and the right to sue for passing off, rights to inventions, rights to use, and all other intellectual property rights, in each case whether registered or unregistered and including all applications and rights to apply for and be granted, rights to claim priority from, such rights and all similar or equivalent rights or forms of protection and any other results of intellectual activity which subsist or will subsist now or in the future in any part of the world. This Agreement does not transfer to you any intellectual property owned by the Operator or third parties, and all rights, titles, and interests in and to such property will remain (as between the parties) solely with the Operator. All trademarks, service marks, graphics and logos used in connection with the Services, are trademarks or registered trademarks of the Operator or its licensors. Other trademarks, service marks, graphics and logos used in connection with the Services may be the trademarks of other third parties. Your use of the Services grants you no right or license to reproduce or otherwise use any of the Operator or third party trademarks.'),
              SizedBox(
                height: Get.height * 0.05,
              ),
              Text(
                '8. Third Party Privacy Policies',
                style: TextStyle(
                  fontSize: Get.width * 0.05,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: Get.height * 0.01,
              ),
              const Text(
                  'To the fullest extent permitted by applicable law, in no event will the Operator, its affiliates, directors, officers, employees, agents, suppliers or licensors be liable to any person for any indirect, incidental, special, punitive, cover or consequential damages (including, without limitation, damages for lost profits, revenue, sales, goodwill, use of content, impact on business, business interruption, loss of anticipated savings, loss of business opportunity) however caused, under any theory of liability, including, without limitation, contract, tort, warranty, breach of statutory duty, negligence or otherwise, even if the liable party has been advised as to the possibility of such damages or could have foreseen such damages. To the maximum extent permitted by applicable law, the aggregate liability of the Operator and its affiliates, officers, employees, agents, suppliers and licensors relating to the services will be limited to an amount greater of one dollar or any amounts actually paid in cash by you to the Operator for the prior one month period prior to the first event or occurrence giving rise to such liability. The limitations and exclusions also apply if this remedy does not fully compensate you for any losses or fails of its essential purpose.'),
              SizedBox(
                height: Get.height * 0.05,
              ),
              Text(
                '9. CCPA Privacy Rights (Do Not Sell My Personal Information)',
                style: TextStyle(
                  fontSize: Get.width * 0.05,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: Get.height * 0.01,
              ),
              const Text(
                  'You agree to indemnify and hold the Operator and its affiliates, directors, officers, employees, agents, suppliers and licensors harmless from and against any liabilities, losses, damages or costs, including reasonable attorneys\' fees, incurred in connection with or arising from any third party allegations, claims, actions, disputes, or demands asserted against any of them as a result of or relating to your Content, your use of the Services or any willful misconduct on your part.'),
              SizedBox(
                height: Get.height * 0.05,
              ),
              Text(
                '10. GDPR Data Protection Rights',
                style: TextStyle(
                  fontSize: Get.width * 0.05,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: Get.height * 0.01,
              ),
              SizedBox(
                height: Get.height * 0.05,
              ),
              Text(
                '11. Children\'s Information',
                style: TextStyle(
                  fontSize: Get.width * 0.05,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: Get.height * 0.01,
              ),
              const Text(
                  'Another part of our priority is adding protection for children while using the internet. We encourage parents and guardians to observe, participate in, and/or monitor and guide their online activity.'),
              SizedBox(
                height: Get.height * 0.05,
              ),
            ],
          ),
        ));
  }
}

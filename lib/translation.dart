import 'package:get/get.dart';

class Translation extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
        'zh': {
          'Vault': '密码保险箱',
          'Password Diagnostics': '密码诊断',
          'Search passwords': '搜索密码',
          'Clear All': '全部清除',
          '+ New password': '+ 生成密码',
          'New Password': '创建密码',
          'Enter password...': '输入密码',
          'Weak': '有潜在威胁',
          'Acceptable': '弱',
          'Secure': '安全',
          'Bulletproof': '固若金汤',
          'Recommended Length: 20 characters and above': '建议长度：大于等于20',
          'Password Length: ': '密码长度: ',
          'Password Length': '密码长度',
          'Time To Crack: ': '破解时间: ',
          'Delete': '清除密码',
          'Saved Password': '保存的密码',
          'Generate': '生成密码',
          'Password': '密码',
          'Save': '保存',
          'Password copied to clipboard': '密码已复制',
          'Your password is now available.': '您的密码可以使用了。',
          'Tag': '标签',
          'What is the password for?': '这是什么密码？',
          'Please provide a tag. Give your password a name.':
              '请输入密码标签，以便区分不同密码',
          'This password already exists. Pick a new tag.': '此标签已存在，请选择新标签',
          'To protect your privacy, this password is encrypted locally and cannot be changed. If you wish to change it in the future, use Maglev Vault to generate a new secure password.':
              '此密码已进行加密并保存于本地iPhone。为确保信息安全，此密码不可篡改。您若需要更改此密码，请创建新的密码并删除此密码。',
          'This tag is encrypted and stored on your phone locally. It is only available to you. You can change it any time.':
              '此标签已经过加密处理并保存于本地。您可以随时更改此标签。',
          'Are you sure?': '要清除密码吗？',
          'Yes, I\'m sure': '确认',
          'No': '取消',
          'Once passwords are all permanently wiped from the vault, they can\'t be recovered.':
              '全部密码将被永久清除。一旦清除，未来将无法恢复。',
          'Once this password is permanently wiped from the vault, it can\'t be recovered.':
              '此密码一旦清除将永久无法恢复。'
        }
      };
}

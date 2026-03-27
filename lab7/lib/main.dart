import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lab 7 - Signup',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
      ),
      home: const SignupScreen(),
    );
  }
}

enum PasswordStrength { weak, medium, strong }

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  final _nameFocus = FocusNode();
  final _emailFocus = FocusNode();
  final _passwordFocus = FocusNode();
  final _confirmPasswordFocus = FocusNode();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _acceptedTerms = false;
  bool _isCheckingEmail = false;
  bool _canSubmit = false;

  @override
  void initState() {
    super.initState();
    _nameController.addListener(_recomputeCanSubmit);
    _emailController.addListener(_recomputeCanSubmit);
    _passwordController.addListener(_recomputeCanSubmit);
    _confirmPasswordController.addListener(_recomputeCanSubmit);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();

    _nameFocus.dispose();
    _emailFocus.dispose();
    _passwordFocus.dispose();
    _confirmPasswordFocus.dispose();
    super.dispose();
  }

  void _recomputeCanSubmit() {
    final next = _localChecksPass() && _acceptedTerms && !_isCheckingEmail;
    if (next != _canSubmit) {
      setState(() => _canSubmit = next);
    }
  }

  bool _localChecksPass() {
    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text;
    final confirm = _confirmPasswordController.text;

    if (name.isEmpty || email.isEmpty || password.isEmpty || confirm.isEmpty) {
      return false;
    }
    if (!_looksLikeEmail(email)) return false;
    if (_validatePassword(password) != null) return false;
    if (confirm != password) return false;
    return true;
  }

  static bool _looksLikeEmail(String email) {
    return email.contains('@') && email.contains('.');
  }

  String? _validateRequired(String? value, String fieldName) {
    final v = value?.trim() ?? '';
    if (v.isEmpty) return '$fieldName là bắt buộc';
    return null;
  }

  String? _validateEmail(String? value) {
    final requiredError = _validateRequired(value, 'Email');
    if (requiredError != null) return requiredError;

    final v = value!.trim();
    if (!_looksLikeEmail(v)) return 'Vui lòng nhập email hợp lệ';
    return null;
  }

  String? _validatePassword(String? value) {
    final requiredError = _validateRequired(value, 'Mật khẩu');
    if (requiredError != null) return requiredError;

    final v = value!;
    if (v.length < 8) return 'Mật khẩu tối thiểu 8 ký tự';
    if (!RegExp(r'[0-9]').hasMatch(v)) return 'Mật khẩu cần ít nhất 1 chữ số';
    return null;
  }

  String? _validateConfirmPassword(String? value) {
    final requiredError = _validateRequired(value, 'Xác nhận mật khẩu');
    if (requiredError != null) return requiredError;

    if ((value ?? '') != _passwordController.text) {
      return 'Mật khẩu xác nhận không khớp';
    }
    return null;
  }

  PasswordStrength _passwordStrength(String password) {
    final hasDigit = RegExp(r'[0-9]').hasMatch(password);
    final hasUpper = RegExp(r'[A-Z]').hasMatch(password);
    final hasLower = RegExp(r'[a-z]').hasMatch(password);
    final hasSymbol = RegExp(r'[^A-Za-z0-9]').hasMatch(password);

    var score = 0;
    if (password.length >= 8) score++;
    if (password.length >= 12) score++;
    if (hasDigit) score++;
    if (hasUpper && hasLower) score++;
    if (hasSymbol) score++;

    if (score >= 4) return PasswordStrength.strong;
    if (score >= 2) return PasswordStrength.medium;
    return PasswordStrength.weak;
  }

  Future<bool> _checkEmailAvailable(String email) async {
    await Future.delayed(const Duration(seconds: 2));
    return !email.toLowerCase().startsWith('taken');
  }

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();

    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) return;
    if (!_acceptedTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Bạn cần đồng ý Điều khoản & Điều kiện')),
      );
      return;
    }

    setState(() => _isCheckingEmail = true);
    _recomputeCanSubmit();

    try {
      final email = _emailController.text.trim();
      final ok = await _checkEmailAvailable(email);
      if (!mounted) return;

      if (!ok) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Email này đã được sử dụng')),
        );
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Đăng ký thành công cho ${_nameController.text.trim()}'),
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isCheckingEmail = false);
        _recomputeCanSubmit();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final password = _passwordController.text;
    final strength = _passwordStrength(password);

    final (strengthText, strengthColor) = switch (strength) {
      PasswordStrength.weak => ('Yếu', Colors.red),
      PasswordStrength.medium => ('Trung bình', Colors.orange),
      PasswordStrength.strong => ('Mạnh', Colors.green),
    };

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Signup'),
        ),
        body: SafeArea(
          child: Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            onChanged: _recomputeCanSubmit,
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Text(
                  'Tạo tài khoản',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Nhập thông tin bên dưới để đăng ký.',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _nameController,
                  focusNode: _nameFocus,
                  decoration: const InputDecoration(
                    labelText: 'Họ và tên',
                    prefixIcon: Icon(Icons.person_outline),
                    border: OutlineInputBorder(),
                  ),
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.name,
                  validator: (v) => _validateRequired(v, 'Họ và tên'),
                  onFieldSubmitted: (_) =>
                      FocusScope.of(context).requestFocus(_emailFocus),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _emailController,
                  focusNode: _emailFocus,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    prefixIcon: Icon(Icons.email_outlined),
                    border: OutlineInputBorder(),
                  ),
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.emailAddress,
                  validator: _validateEmail,
                  onFieldSubmitted: (_) =>
                      FocusScope.of(context).requestFocus(_passwordFocus),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _passwordController,
                  focusNode: _passwordFocus,
                  decoration: InputDecoration(
                    labelText: 'Mật khẩu',
                    prefixIcon: const Icon(Icons.lock_outline),
                    border: const OutlineInputBorder(),
                    suffixIcon: IconButton(
                      onPressed: () =>
                          setState(() => _obscurePassword = !_obscurePassword),
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                      ),
                      tooltip: _obscurePassword ? 'Hiện' : 'Ẩn',
                    ),
                  ),
                  obscureText: _obscurePassword,
                  textInputAction: TextInputAction.next,
                  validator: _validatePassword,
                  onFieldSubmitted: (_) =>
                      FocusScope.of(context).requestFocus(_confirmPasswordFocus),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Text('Độ mạnh: '),
                    Text(
                      strengthText,
                      style: TextStyle(
                        color: strengthColor,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _confirmPasswordController,
                  focusNode: _confirmPasswordFocus,
                  decoration: InputDecoration(
                    labelText: 'Xác nhận mật khẩu',
                    prefixIcon: const Icon(Icons.lock_outline),
                    border: const OutlineInputBorder(),
                    suffixIcon: IconButton(
                      onPressed: () => setState(() =>
                          _obscureConfirmPassword = !_obscureConfirmPassword),
                      icon: Icon(
                        _obscureConfirmPassword
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                      ),
                      tooltip: _obscureConfirmPassword ? 'Hiện' : 'Ẩn',
                    ),
                  ),
                  obscureText: _obscureConfirmPassword,
                  textInputAction: TextInputAction.done,
                  validator: _validateConfirmPassword,
                  onFieldSubmitted: (_) => _submit(),
                ),
                const SizedBox(height: 8),
                CheckboxListTile(
                  contentPadding: EdgeInsets.zero,
                  value: _acceptedTerms,
                  onChanged: (v) {
                    setState(() => _acceptedTerms = v ?? false);
                    _recomputeCanSubmit();
                  },
                  title: const Text('Tôi đồng ý Điều khoản & Điều kiện'),
                  controlAffinity: ListTileControlAffinity.leading,
                ),
                const SizedBox(height: 12),
                SizedBox(
                  height: 48,
                  child: ElevatedButton(
                    onPressed: _canSubmit ? _submit : null,
                    child: _isCheckingEmail
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text('Đăng ký'),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Gợi ý: Email bắt đầu bằng "taken" sẽ bị báo đã tồn tại.',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

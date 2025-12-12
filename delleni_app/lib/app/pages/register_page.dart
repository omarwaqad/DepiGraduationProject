import 'package:delleni_app/app/pages/login.dart';
import 'package:delleni_app/app/pages/main_layout.dart';
import 'package:delleni_app/features/auth/presentation/controllers/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RegisterPage extends StatelessWidget {
  RegisterPage({super.key});

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final phoneController = TextEditingController();
  final addressController = TextEditingController();
  final AuthController auth = Get.find<AuthController>();

  final RxBool isPasswordObscured = true.obs;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F5F5),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 32.0,
                vertical: 24.0,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24.0,
                      vertical: 32.0,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Icon
                        Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFE7D8),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: const Icon(
                            Icons.person_add_alt_1_rounded,
                            color: Color(0xFFDD755A),
                            size: 30,
                          ),
                        ),
                        const SizedBox(height: 24),

                        const Text(
                          'إنشاء حساب جديد',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),

                        const Text(
                          'انضم إلى مجتمع دلني واستفد من خدماتنا',
                          style: TextStyle(fontSize: 14, color: Colors.grey),
                        ),
                        const SizedBox(height: 24),

                        // First name
                        const Text(
                          'الاسم الأول',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextField(
                          controller: firstNameController,
                          decoration: _fieldDecoration('الاسم الأول'),
                        ),
                        const SizedBox(height: 16),

                        // Last name
                        const Text(
                          'اسم العائلة',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextField(
                          controller: lastNameController,
                          decoration: _fieldDecoration('اسم العائلة'),
                        ),
                        const SizedBox(height: 16),

                        // Email
                        const Text(
                          'البريد الإلكتروني',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextField(
                          controller: emailController,
                          decoration: _fieldDecoration('name@example.com'),
                          keyboardType: TextInputType.emailAddress,
                        ),
                        const SizedBox(height: 16),

                        // Phone
                        const Text(
                          'رقم الهاتف',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextField(
                          controller: phoneController,
                          decoration: _fieldDecoration('رقم الهاتف'),
                          keyboardType: TextInputType.phone,
                        ),
                        const SizedBox(height: 16),

                        // Address
                        const Text(
                          'العنوان',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextField(
                          controller: addressController,
                          decoration: _fieldDecoration('العنوان'),
                        ),
                        const SizedBox(height: 16),

                        // Password
                        const Text(
                          'كلمة المرور',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Obx(
                          () => TextField(
                            controller: passwordController,
                            obscureText: isPasswordObscured.value,
                            decoration: _fieldDecoration('').copyWith(
                              suffixIcon: IconButton(
                                icon: Icon(
                                  isPasswordObscured.value
                                      ? Icons.visibility_outlined
                                      : Icons.visibility_off_outlined,
                                ),
                                onPressed: () {
                                  isPasswordObscured.value =
                                      !isPasswordObscured.value;
                                },
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),

                        const Text(
                          'تأكيد كلمة المرور',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextField(
                          controller: confirmPasswordController,
                          obscureText: true,
                          decoration: _fieldDecoration(''),
                        ),
                        const SizedBox(height: 24),

                        SizedBox(
                          height: 48,
                          child: Obx(
                            () => ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFDD755A),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(24),
                                ),
                              ),
                              onPressed: auth.isLoading.value
                                  ? null
                                  : () async {
                                      final firstname = firstNameController.text.trim();
                                      final lastname = lastNameController.text.trim();
                                      final email = emailController.text.trim();
                                      final phonenumber = phoneController.text.trim();
                                      final address = addressController.text.trim();
                                      final password = passwordController.text;
                                      final confirmPassword =
                                          confirmPasswordController.text;

                                      // Validation
                                      if (firstname.isEmpty ||
                                          lastname.isEmpty ||
                                          email.isEmpty ||
                                          phonenumber.isEmpty ||
                                          address.isEmpty ||
                                          password.isEmpty) {
                                        Get.snackbar(
                                          'خطأ',
                                          'الرجاء ملء جميع الحقول',
                                          backgroundColor: Colors.red.shade100,
                                          colorText: Colors.red.shade900,
                                        );
                                        return;
                                      }

                                      if (password != confirmPassword) {
                                        Get.snackbar(
                                          'خطأ',
                                          'كلمات المرور غير متطابقة',
                                          backgroundColor: Colors.red.shade100,
                                          colorText: Colors.red.shade900,
                                        );
                                        return;
                                      }

                                      if (password.length < 6) {
                                        Get.snackbar(
                                          'خطأ',
                                          'كلمة المرور يجب أن تكون 6 أحرف على الأقل',
                                          backgroundColor: Colors.red.shade100,
                                          colorText: Colors.red.shade900,
                                        );
                                        return;
                                      }

                                      final (ok, msg) = await auth.register(
                                        firstName: firstname,
                                        lastName: lastname,
                                        email: email,
                                        phone: phonenumber,
                                        address: address,
                                        password: password,
                                      );

                                      if (ok) {
                                        Get.snackbar(
                                          'نجح',
                                          'تم إنشاء الحساب بنجاح',
                                          backgroundColor: Colors.green.shade100,
                                          colorText: Colors.green.shade900,
                                        );
                                        // Navigate to main app after successful registration
                                        Get.offAll(() => const MainLayout());
                                      } else {
                                        Get.snackbar(
                                          'خطأ',
                                          msg ?? 'فشل إنشاء الحساب',
                                          backgroundColor: Colors.red.shade100,
                                          colorText: Colors.red.shade900,
                                        );
                                      }
                                    },
                              child: auth.isLoading.value
                                  ? const SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(Colors.white),
                                      ),
                                    )
                                  : const Text(
                                      'إنشاء الحساب',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white,
                                      ),
                                    ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // "Already have account?"
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'لديك حساب بالفعل؟ ',
                        style: TextStyle(fontSize: 14, color: Colors.black87),
                      ),
                      GestureDetector(
                        onTap: () {
                          Get.offAll(() => Login());
                        },
                        child: const Text(
                          'تسجيل الدخول',
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xFFDD755A),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _fieldDecoration(String hint) {
    return InputDecoration(
      hintText: hint.isEmpty ? null : hint,
      filled: true,
      fillColor: const Color(0xFFF8F8F8),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFDD755A), width: 1.5),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    );
  }
}

import os
import re

file_path = r'c:\Users\Earthen\dev\college\swifttrip\frontend\lib\screens\home\home.dart'
dest_path = r'c:\Users\Earthen\dev\college\swifttrip\frontend\lib\screens\home\widgets\review_popup.dart'

with open(file_path, 'r', encoding='utf-8') as f:
    content = f.read()

# try to isolate _showReviewPopup
start_idx = content.find('void _showReviewPopup() {')
if start_idx != -1:
    # find the end of method
    # It ends right before `@override\n  Widget build`
    end_idx = content.find('  @override\n  Widget build(BuildContext context) {', start_idx)
    if end_idx != -1:
        method_str = content[start_idx:end_idx]
        
        # Now find the Dialog(...) part
        dialog_start = method_str.find('Dialog(')
        # the dialog ends at the end of the method
        # right before `    );\n  }`
        # Let's just find the last `);`
        last_paren_idx = method_str.rfind(');')
        
        if dialog_start != -1 and last_paren_idx != -1:
            dialog_code = method_str[dialog_start:last_paren_idx].strip()
            # It might end with `)` followed by `\n      ),` etc. 
            # We want just the Dialog Widget.
            # Usually `showDialog` takes `builder: (_) => Dialog(...)`
            # and ends with `    );\n  }`
            # we need to be careful with parentheses. 
            # simpler approach:
            
            # just take from `builder: (_) => ` up to the end of method
            builder_idx = method_str.find('builder: (_) => ')
            if builder_idx != -1:
                builder_code = method_str[builder_idx + len('builder: (_) => '):]
                # builder_code now has `Dialog( .... \n      ),\n    );\n  }\n`
                # drop the last `,\n    );\n  }\n`
                # find the last `);` in builder_code
                b_last_paren = builder_code.rfind(');')
                if b_last_paren != -1:
                    dialog_code_final = builder_code[:b_last_paren].strip()
                    # drop the trailing comma if present
                    if dialog_code_final.endswith(','):
                        dialog_code_final = dialog_code_final[:-1].strip()
                        
                    widget_code = f"""import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../review.dart';

class ReviewPopupWidget extends StatelessWidget {{
  const ReviewPopupWidget({{super.key}});

  @override
  Widget build(BuildContext context) {{
    return {dialog_code_final};
  }}
}}
"""
                    with open(dest_path, 'w', encoding='utf-8') as f:
                        f.write(widget_code)

                    replaced_home = content[:start_idx] + """void _showReviewPopup() {
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.4),
      builder: (_) => const ReviewPopupWidget(),
    );
  }
""" + content[end_idx:]

                    import_statement = "import 'widgets/review_popup.dart';"
                    if import_statement not in replaced_home:
                        replaced_home = replaced_home.replace("import '../main/main_screen.dart';", "import '../main/main_screen.dart';\n" + import_statement)

                    with open(file_path, 'w', encoding='utf-8') as f:
                        f.write(replaced_home)
                    print("Success")
                else:
                    print("Failed to find );")
            else:
                print("Failed to find builder")
        else:
            print("Failed to find Dialog")
    else:
        print("Failed to find end of method")
else:
    print("Failed to find start")

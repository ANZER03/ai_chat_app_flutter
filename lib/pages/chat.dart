import 'package:ai_chat_app/widgets/ai_message.dart';
import 'package:ai_chat_app/widgets/drawer.dart';
import 'package:ai_chat_app/widgets/user_message.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class Chat extends StatefulWidget {
  Chat({Key? key}) : super(key: key);

  @override
  _ChatState createState() => _ChatState();
}

PopupMenuItem<String> _buildPopupMenuItem({
  required String value,
  required String title,
  required String description,
  required String slectedModel,
}) {
  return PopupMenuItem<String>(
    value: value,
    child: Container(
      // Set a fixed width for the menu item
      width:
          500, // You can adjust this value to make the menu wider or narrower
      // Add vertical padding to create space between items
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        margin: EdgeInsets.all(6),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.transparent, width: 1.2),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 18,
                  ),
                ),
                Text(
                  description,
                  style: const TextStyle(fontSize: 13, color: Colors.black54),
                ),
              ],
            ),
            Visibility(
              visible: slectedModel == value ? true : false,
              maintainSize: true,
              maintainAnimation: true,
              maintainState: true,
              child: Icon(Icons.task_alt, color: Colors.black, size: 19),
            ),
          ],
        ),
      ),
    ),
  );
}

class _ChatState extends State<Chat> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController _textController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  bool isPressedThink = false;
  bool isPressedDeepSearch = false;
  String slectedModel = "gemini";

  final List<Map<String, String>> _messages = [
    {
      "role": "user",
      "message":
          "An AI agent is a system or program designed to autonomously perform tasks on behalf of a user or another system. It perceives its environment, reasons, plans, and then acts to achieve specific goals. AI agents can learn and improve their performance over time through machine learning or by acquiring knowledge.",
    },
    {
      "role": "ai",
      "message": '''
An AI agent is a system or program designed to autonomously perform tasks on behalf of a user or another system. It perceives its environment, reasons, plans, and then acts to achieve specific goals. AI agents can learn and improve their performance over time through machine learning or by acquiring knowledge.

Here's a breakdown of the key aspects of AI agents:

* **Autonomy:** AI agents can perform tasks independently without requiring constant human intervention. They can operate and make decisions independently to achieve a goal.
* **Perception:** They perceive their environment through sensors (physical or software interfaces) and collect data.
* **Reasoning:** AI agents use logic and available information to draw conclusions, make inferences, and solve problems. They make rational decisions based on their perceptions and data to produce optimal performance and results.
* **Goal-Oriented:** AI agents are designed to achieve specific goals, which are either pre-defined or set by humans.
* **Action:** They can act or perform tasks based on decisions, plans, or external input to interact with their environment and achieve goals.
* **Learning:** AI agents can learn from their experiences and improve over time. They adapt to new situations, refine their decision-making processes, and respond more effectively.
* **Collaboration:** AI agents can work with other agents to coordinate and perform more complex workflows.
* **Task Automation:** AI agents can automate complex tasks that would otherwise require human resources, leading to increased efficiency and productivity.
''',
    },
    {
      "role": "user",
      "message":
          "An AI agent is a system or program designed to autonomously perform tasks on behalf of a user or another system. It perceives its environment, reasons, plans, and then acts to achieve specific goals. AI agents can learn and improve their performance over time through machine learning or by acquiring knowledge.",
    },
    {
      "role": "ai",
      "message": r'''
Okay, let's break down the evaluation of your generated query against the complex request and the schema.

**Evaluation:**

The query is **very close** and demonstrates a good understanding of the requirements, but it has **one significant potential flaw** related to the category hierarchy and a **minor redundancy**.

**Correct Aspects:**

1.  **Target Columns:** `SELECT c.email, SUM(o.total_amount) AS total_lifetime_spending` correctly selects the customer's email and calculates the total spending.
2.  **Core Joins:** It correctly joins `customers`, `orders`, `order_items`, and `products`.
3.  **Filtering:**
    *   `o.status = 'delivered'`: Correctly filters orders for the spending calculation.
    *   `o.order_date > $1`: Correctly filters by order date using a placeholder.
    *   `'premium' = ANY(p.tags)`: Correctly checks the product tags array.
    *   `c.last_name != 'Smith'`: Correctly excludes customers with the last name 'Smith'.
4.  **Aggregation:** `GROUP BY c.id, c.email` correctly groups by customer to sum their spending.
5.  **Ordering & Limiting:** `ORDER BY total_lifetime_spending DESC LIMIT 5` correctly identifies and limits to the top 5 customers based on the calculated spending.
6.  **Parameterization:** Uses `$1` correctly for the date.

**Potential Flaw / Area for Improvement:**

1.  **Category Hierarchy Logic:**
    *   The way subcategories are handled is clever but **not fully recursive** and potentially **inefficient/fragile**.
    *   `JOIN categories base_cat ON base_cat.name = 'Electronics'` finds the 'Electronics' category ID.
    *   The `JOIN categories cat ON (...)` condition:
        *   `cat.id = base_cat.id`: Checks if the product is directly in 'Electronics'. (Correct)
        *   `OR cat.parent_category_id = base_cat.id`: Checks if the product is in a *direct child* category of 'Electronics'. (Correct)
        *   `OR cat.parent_category_id IN (SELECT id FROM categories WHERE parent_category_id = base_cat.id)`: This checks if the product's *parent category* is a *child* of 'Electronics', meaning the product itself is in a *grandchild* category of 'Electronics'. (Correct for one level deeper).
    *   **Issue:** This hardcoded logic only handles the base category, direct children, and grandchildren. If 'Electronics' had sub-sub-subcategories, products within those would be missed. The robust way to handle arbitrary depth in PostgreSQL is using a **Recursive Common Table Expression (CTE)**.

**Minor Redundancy:**

1.  **`HAVING COUNT(oi.id) > 0`**: This condition is technically redundant. Because you are using `INNER JOIN` across `customers`, `orders`, `order_items`, `products`, and `categories`, and applying filters in the `WHERE` clause, any customer record that makes it to the `GROUP BY` stage *must* have had at least one `order_item` that satisfied all the preceding conditions. The `INNER JOIN`s implicitly handle the "at least one" requirement established by the `WHERE` clause filters. Removing this `HAVING` clause would likely yield the same result with slightly less computation.

**Conclusion:**

The query is **largely correct** and addresses most requirements accurately. The main issue is the **non-recursive handling of the category hierarchy**. For a schema where categories might have arbitrary depth, this query would fail to capture products in deeper subcategories. The use of a recursive CTE would make it fully correct and robust for any category structure. The `HAVING` clause is redundant but doesn't cause incorrect results.

**Improved Version (Conceptual - using Recursive CTE):**

```sql
WITH RECURSIVE category_tree AS (
    -- Anchor member: Find the 'Electronics' category
    SELECT id
    FROM categories
    WHERE name = 'Electronics'
    UNION ALL
    -- Recursive member: Find all child categories
    SELECT c.id
    FROM categories c
    INNER JOIN category_tree ct ON c.parent_category_id = ct.id
)
SELECT
    c.email,
    SUM(o.total_amount) AS total_lifetime_spending
FROM customers c
JOIN orders o ON o.customer_id = c.id
JOIN order_items oi ON oi.order_id = o.id
JOIN products p ON p.id = oi.product_id
JOIN category_tree ct ON p.category_id = ct.id -- Join product category against the full tree
WHERE
    o.status = 'delivered'
    AND o.order_date > $1 -- e.g., '2023-01-01'
    AND 'premium' = ANY(p.tags)
    AND c.last_name != 'Smith'
GROUP BY c.id, c.email -- Grouping by c.id is sufficient as it's the PK
ORDER BY total_lifetime_spending DESC
LIMIT 5;
```
 ''',
    },
  ];
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // _focusNode.addListener removed: no longer managing readOnly state
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _textController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawerEdgeDragWidth: MediaQuery.of(context).size.width,
      backgroundColor: const Color(0xFFF8F6F5),
      drawer: DrawerWidget(),
      appBar: AppBar(
        scrolledUnderElevation: 0.0,
        backgroundColor: const Color(0xFFF8F6F5),
        leading: IconButton(
          icon: const Icon(Icons.sort),
          onPressed: () {
            FocusScope.of(context).unfocus(); // Ensure keyboard hides
            _scaffoldKey.currentState?.openDrawer();
          },
        ),
        title: PopupMenuButton<String>(
          offset: const Offset(0, 45),
          onSelected: (String value) {
            setState(() {
              slectedModel = value;
            });
            print('Selected model: $value');
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Anzer',
                style: GoogleFonts.ubuntu(
                  fontSize: 19,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
              const Icon(Icons.keyboard_arrow_down, color: Color.fromARGB(255, 99, 95, 95)),
            ],
          ),
          itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
            _buildPopupMenuItem(
              value: 'gemini',
              title: 'Gemini 2.5',
              description: 'Smart',
              slectedModel: slectedModel,
            ),
            _buildPopupMenuItem(
              value: 'llama',
              title: 'Llama 4',
              description: 'Fast',
              slectedModel: slectedModel,
            ),
            _buildPopupMenuItem(
              value: 'gpt-4',
              title: 'GPT 4.1',
              description: 'Coding',
              slectedModel: slectedModel,
            ),
          ],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          color: const Color(0xFFFCFCFC),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.maps_ugc_outlined),
            onPressed: () {
              // Handle new page creation
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Scrollbar(
              controller: _scrollController,
              child: ListView.builder(
                controller: _scrollController,
                itemCount: _messages.length,
                reverse: true,
                itemBuilder: (context, index) {
                  final message = _messages.reversed.toList()[index];
                  if (message['role'] == 'user') {
                    return UserMessage(message: message['message']!);
                  } else {
                    return AiMessage(message: message['message']!);
                  }
                },
              ),
            ),
          ),
          // Fixed Bottom Container
          Container(
            decoration: BoxDecoration(
              color: Colors.transparent,
              border: Border.all(color: const Color(0xFFE4E4E2), width: 1.2),
              borderRadius: BorderRadius.circular(30),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
            margin: const EdgeInsets.fromLTRB(10, 1, 10, 5),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: SingleChildScrollView(
                    reverse: true, // ensures keyboard doesn’t cover content
                    child: TextField(
                      controller: _textController,
                      focusNode: _focusNode,
                      // readOnly is always false by default (line removed)
                      // onTap logic is unnecessary (line removed)
                      autofocus: false,
                      onChanged: (text) {
                        setState(() {});
                      },
                      cursorColor: const Color.fromARGB(255, 46, 46, 46),
                      maxLines: 6,
                      minLines: 1,
                      decoration: const InputDecoration(
                        floatingLabelBehavior: FloatingLabelBehavior.never,
                        hintText: 'Ask Anzer',
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(vertical: 4),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 2),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Color(0xFFEFEFED),
                            borderRadius: BorderRadius.circular(40),
                          ),
                          child: PopupMenuButton<String>(
                            tooltip: 'Attach',
                            icon: const Icon(Icons.attach_file, size: 24, color: Color(0xFF141313)),
                            color: Colors.white,
                            offset: const Offset(0, -230), // Larger negative y for more margin below menu
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0), // Strongly rounded menu corners
                            ),
                            onSelected: (String value) {
                              print('Selected: $value');
                            },
                            itemBuilder: (BuildContext context) => [
                              PopupMenuItem(
                                value: 'camera',
                                child: Padding(
                                  padding: const EdgeInsets.only(bottom: 23.0),
                                  child: Row(
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          color: Color.fromARGB(255, 255, 255, 255),
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            color: Color(0xFFE4E4E2),
                                            width: 1.2,
                                          ),
                                        ),
                                        child: CircleAvatar(
                                          backgroundColor: Colors.transparent,
                                          radius: 18,
                                          child: Icon(
                                            Icons.camera_alt_outlined,
                                            color: Colors.black87,
                                            size: 18,
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 13),
                                      Text('Camera', style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15)),
                                    ],
                                  ),
                                ),
                              ),
                              PopupMenuItem(
                                value: 'photos',
                                child: Padding(
                                  padding: const EdgeInsets.only(bottom: 23.0),
                                  child: Row(
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          color: Color.fromARGB(255, 255, 255, 255),
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            color: Color(0xFFE4E4E2),
                                            width: 1.2,
                                          ),
                                        ),
                                        child: CircleAvatar(
                                          backgroundColor: Color.fromARGB(255, 255, 255, 255),
                                          radius: 18,
                                          child: Icon(
                                            Icons.photo_outlined,
                                            color: Colors.black87,
                                            size: 18,
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 13),
                                      Text('Photos', style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15)),
                                    ],
                                  ),
                                ),
                              ),
                              PopupMenuItem(
                                value: 'files',
                                child: Row(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        color: Color.fromARGB(255, 255, 255, 255),
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: Color(0xFFE4E4E2),
                                          width: 1.2,
                                        ),
                                      ),
                                      child: CircleAvatar(
                                        backgroundColor: Color.fromARGB(255, 255, 255, 255),
                                        radius: 18,
                                        child: Icon(
                                          Icons.insert_drive_file_outlined,
                                          color: Colors.black87,
                                          size: 18,
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 13),
                                    Text('Files', style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15)),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 10),
                        TextButton.icon(
                          style: TextButton.styleFrom(
                            side: BorderSide(
                              color: isPressedDeepSearch
                                  ? Colors.transparent
                                  : const Color(0xFFE4E4E2),
                              width: 0,
                            ),
                            backgroundColor: isPressedDeepSearch
                                ? const Color(0xFF141313)
                                : const Color(0xFFEFEFED),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 13,
                              vertical: 10,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(40),
                            ),
                          ),
                          icon: Icon(
                            Icons.public,
                            color: isPressedDeepSearch
                                ? Colors.white
                                : const Color(0xFF141313),
                            size: 20,
                          ),
                          label: Text(
                            'DeepSearch',
                            style: GoogleFonts.ubuntu(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: isPressedDeepSearch
                                  ? Colors.white
                                  : const Color(0xFF141313),
                            ),
                          ),
                          onPressed: () {
                            setState(() {
                              isPressedDeepSearch = !isPressedDeepSearch;
                            });
                          },
                        ),
                        const SizedBox(width: 10),
                        TextButton.icon(
                          style: TextButton.styleFrom(
                            side: BorderSide(
                              color: isPressedThink
                                  ? Colors.transparent
                                  : const Color(0xFFE4E4E2),
                              width: 0,
                            ),
                            backgroundColor: isPressedThink
                                ? const Color(0xFF141313)
                                : const Color(0xFFEFEFED),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 13,
                              vertical: 10,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(40),
                            ),
                          ),
                          icon: Icon(
                            Icons.lightbulb_outlined,
                            color: isPressedThink
                                ? Colors.white
                                : const Color(0xFF141313),
                            size: 20,
                          ),
                          label: Text(
                            'Think',
                            style: GoogleFonts.ubuntu(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: isPressedThink
                                  ? Colors.white
                                  : const Color(0xFF141313),
                            ),
                          ),
                          onPressed: () {
                            setState(() {
                              isPressedThink = !isPressedThink;
                            });
                          },
                        ),
                      ],
                    ),
                    IconButton(
                        style: IconButton.styleFrom(
                          backgroundColor: const Color.fromARGB(255, 0, 0, 0),
                          fixedSize: _textController.text.isEmpty
                              ? const Size(35, 35)
                              : const Size(40, 40),
                        ),
                        icon: Icon(
                          _textController.text.isEmpty
                              ? Icons.graphic_eq
                              : Icons.send,
                          size: _textController.text.isEmpty
                              ? 22
                              : 25,
                          color: const Color.fromARGB(255, 255, 255, 255),
                        ),
                        onPressed: () {}),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

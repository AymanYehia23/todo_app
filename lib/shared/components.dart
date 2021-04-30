import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/shared/cubit/appCubit.dart';

Widget defaultFormField({
  @required TextEditingController controller,
  TextInputType type,
  Function onSubmit,
  Function onChange,
  Function onTap,
  bool isPassword = false,
  bool isReadOnly = false,
  @required Function validate,
  @required String label,
  @required IconData prefix,
  IconData suffix,
  Function suffixPressed,
  bool isClickable = true,
}) =>
    TextFormField(
      controller: controller,
      keyboardType: type,
      obscureText: isPassword,
      enabled: isClickable,
      onFieldSubmitted: onSubmit,
      onChanged: onChange,
      onTap: onTap,
      validator: validate,
      readOnly: isReadOnly,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(
          prefix,
        ),
        suffixIcon: suffix != null
            ? IconButton(
          onPressed: suffixPressed,
          icon: Icon(
            suffix,
          ),
        )
            : null,
        border: OutlineInputBorder(),
      ),
    );

Widget buildTaskItem (Map model, BuildContext context) => Dismissible(
  key: Key(model['id'].toString()),
  child: Padding(

    padding: const EdgeInsets.all(20.0),

    child: Row(

      children: [

        CircleAvatar(

          radius: 40.0,

          child: Text(

            '${model['time']}',

          ),

        ),

        SizedBox(width: 20,),

        Expanded(

          child: Column(

            mainAxisSize: MainAxisSize.min,

            crossAxisAlignment: CrossAxisAlignment.start,

            children: [

              Text(

                '${model['title']}',

                style: TextStyle(

                  fontSize: 18.0,

                  fontWeight: FontWeight.bold,

                ),

              ),

              Text(

                '${model['date']}',

                style: TextStyle(

                    color: Colors.grey

                ),

              ),

            ],

          ),

        ),

        IconButton(

          icon: Icon(Icons.check_box,),

          color: Colors.green,

          onPressed: (){

            AppCubit.get(context).updateData('done', model['id']);

          },

        ),

        IconButton(

          icon: Icon(Icons.archive_outlined,),

          color: Colors.black54,

          onPressed: (){

            AppCubit.get(context).updateData('archive', model['id']);

          },

        ),

      ],

    ),

  ),
  onDismissed: (value){
    AppCubit.get(context).deleteData(model['id']);
  },
);

Widget buildTasks (List<Map> tasks) => ConditionalBuilder(
  condition: tasks.length > 0,
  builder: (BuildContext context) => ListView.separated(
    itemBuilder: (context,index) => buildTaskItem(tasks[index],context),
    separatorBuilder: (context,index) => Padding(
      padding: const EdgeInsetsDirectional.only(start: 20.0),
      child: Container(
        color: Colors.grey[300],
        height: 1,
      ),
    ),
    itemCount: tasks.length,
  ),
  fallback: (BuildContext context) => Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.menu,
          size: 100,
          color: Colors.grey,
        ),
        Text(
          'No Tasks Yet! Please Add Some Tasks',
          style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold
          ),
        )
      ],
    ),
  ),
);

//
//  spam.c
//  PythonXcode01
//
//  Created by acb on 2020-06-18.
//  Copyright © 2020 acb. All rights reserved.
//

#include "spam.h"
#include <Python/Python.h>

#import "spam-Swift.h"

static PyObject *SpamError;


static PyObject *
spam_add(PyObject *self, PyObject *args) {
    int a;
    int b;
    if(!PyArg_ParseTuple(args, "ii", &a, &b)) { return NULL; }
    return Py_BuildValue("i", [Glue add:a :b]);
//    return Py_BuildValue("i", a+b);
}

static PyMethodDef SpamMethods[] = {
//    {"system",  spam_system, METH_VARARGS,
//     "Execute a shell command."},
    {"add", spam_add, METH_VARARGS, "Add two numbers"},
    {NULL, NULL, 0, NULL}        /* Sentinel */
};

PyMODINIT_FUNC
initspam(void)
{
    PyObject *m;

    m = Py_InitModule("spam", SpamMethods);
    if (m == NULL)
        return;

    SpamError = PyErr_NewException("spam.error", NULL, NULL);
    Py_INCREF(SpamError);
    PyModule_AddObject(m, "error", SpamError);
}

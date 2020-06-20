//
//  spam.c
//  PythonXcode01
//
//  Created by acb on 2020-06-18.
//  Copyright © 2020 acb. All rights reserved.
//

#include "spam.h"
#include <Python/Python.h>
#include <Python/structmember.h>

#import "spam-Swift.h"

static PyObject *SpamError;


///MARK: the counter type

typedef struct {
    PyObject_HEAD
    Counter *instance;
} spam_CounterObject;

static PyObject *
Counter_new(PyTypeObject *type, PyObject *args, PyObject *kwds) {
    spam_CounterObject *self;
    
    self = (spam_CounterObject *)type->tp_alloc(type, 0);
    if (self != NULL) {
        self->instance = [[Counter alloc] init];
    }
    
    return (PyObject *)self;
}

static void
Counter_dealloc(spam_CounterObject *self) {
    self->instance = NULL;
}

static int
Counter_init(spam_CounterObject *self, PyObject *args, PyObject *kw) {
    return 0;
}

//MARK: Counter methods
static PyObject *
Counter_increment(spam_CounterObject *self) {
    [self->instance increment];
    Py_INCREF(Py_None);
    return Py_None;
}

static PyObject *
Counter_reset(spam_CounterObject *self) {
    [self->instance reset];
    Py_INCREF(Py_None);
    return Py_None;
}

static PyMethodDef Counter_methods[] = {
    { "increment",  (PyCFunction)Counter_increment, METH_NOARGS, "Increment the counter" },
    { "reset",  (PyCFunction)Counter_reset, METH_NOARGS, "Reset the counter" },
    {NULL}  /* Sentinel */
};

//MARK: Counter getters/setters
PyObject *
Counter_getCount(spam_CounterObject *self, void *closure) {
    return Py_BuildValue("i", [self->instance count]);
}

static int
Counter_setCount(spam_CounterObject  *self, PyObject *value, void *closure) {
    PyErr_SetString(PyExc_ValueError, "Setting the counter value is not permitted");
    return -1;
}

static PyGetSetDef Counter_getsetters[] = {
    { "count", (getter)Counter_getCount, (setter)Counter_setCount, "count", NULL},
    {  NULL }
};

static PyObject *
Counter_repr(spam_CounterObject *self) {
    return PyString_FromFormat("<spam.Counter; count:%i>", (long)[self->instance count]);
}

static PyTypeObject spam_CounterType = {
    PyVarObject_HEAD_INIT(NULL, 0)
    "spam.Counter",             /* tp_name */
    sizeof(spam_CounterObject), /* tp_basicsize */
    0,                         /* tp_itemsize */
    (destructor)Counter_dealloc, /* tp_dealloc */
    0,                         /* tp_print */
    0,                         /* tp_getattr */
    0,                         /* tp_setattr */
    0,                         /* tp_compare */
    (reprfunc)Counter_repr,    /* tp_repr */
    0,                         /* tp_as_number */
    0,                         /* tp_as_sequence */
    0,                         /* tp_as_mapping */
    0,                         /* tp_hash */
    0,                         /* tp_call */
    0,                         /* tp_str */
    0,                         /* tp_getattro */
    0,                         /* tp_setattro */
    0,                         /* tp_as_buffer */
    Py_TPFLAGS_DEFAULT,        /* tp_flags */
    "Counter",           /* tp_doc */
    0,                         /* tp_traverse */
    0,                         /* tp_clear */
    0,                         /* tp_richcompare */
    0,                         /* tp_weaklistoffset */
    0,                         /* tp_iter */
    0,                         /* tp_iternext */
    Counter_methods,           /* tp_methods */
    0,                         /* tp_members */
    Counter_getsetters,        /* tp_getset */
    0,                         /* tp_base */
    0,                         /* tp_dict */
    0,                         /* tp_descr_get */
    0,                         /* tp_descr_set */
    0,                         /* tp_dictoffset */
    (initproc)Counter_init,    /* tp_init */
    0,                         /* tp_alloc */
    Counter_new,               /* tp_new */};

///MARK: functions

static PyObject *
spam_add(PyObject *self, PyObject *args) {
    int a;
    int b;
    if(!PyArg_ParseTuple(args, "ii", &a, &b)) { return NULL; }
    return Py_BuildValue("i", [Glue add:a :b]);
}

static PyMethodDef SpamMethods[] = {
    {"add", spam_add, METH_VARARGS, "Add two numbers"},
    {NULL, NULL, 0, NULL}        /* Sentinel */
};

PyMODINIT_FUNC
initspam(void)
{
    PyObject *m;
    
    if (PyType_Ready(&spam_CounterType) < 0) {
        return;
    }

    m = Py_InitModule("spam", SpamMethods);
    if (m == NULL)
        return;

    SpamError = PyErr_NewException("spam.error", NULL, NULL);
    Py_INCREF(SpamError);
    PyModule_AddObject(m, "error", SpamError);
    
    Py_INCREF(&spam_CounterType);
    PyModule_AddObject(m, "Counter", (PyObject *)&spam_CounterType);
}

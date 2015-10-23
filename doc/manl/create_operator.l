.\\" auto-generated by docbook2man-spec $Revision: 1.1.1.1 $
.TH "CREATE OPERATOR" "" "2010-12-13" "SQL - Language Statements" "SQL Commands"
.SH NAME
CREATE OPERATOR \- define a new operator

.SH SYNOPSIS
.sp
.nf
CREATE OPERATOR \fIname\fR (
    PROCEDURE = \fIfuncname\fR
    [, LEFTARG = \fIlefttype\fR ] [, RIGHTARG = \fIrighttype\fR ]
    [, COMMUTATOR = \fIcom_op\fR ] [, NEGATOR = \fIneg_op\fR ]
    [, RESTRICT = \fIres_proc\fR ] [, JOIN = \fIjoin_proc\fR ]
    [, HASHES ] [, MERGES ]
    [, SORT1 = \fIleft_sort_op\fR ] [, SORT2 = \fIright_sort_op\fR ]
    [, LTCMP = \fIless_than_op\fR ] [, GTCMP = \fIgreater_than_op\fR ]
)
.sp
.fi
.SH "DESCRIPTION"
.PP
\fBCREATE OPERATOR\fR defines a new operator,
\fIname\fR. The user who
defines an operator becomes its owner. If a schema name is given
then the operator is created in the specified schema. Otherwise it
is created in the current schema.
.PP
The operator name is a sequence of up to \fBNAMEDATALEN\fR-1
(63 by default) characters from the following list:
.sp
.nf
+ - * / < > = ~ ! @ # % ^ & | ` ?
.sp
.fi
There are a few restrictions on your choice of name:
.TP 0.2i
\(bu
-- and /* cannot appear anywhere in an operator name,
since they will be taken as the start of a comment.
.TP 0.2i
\(bu
A multicharacter operator name cannot end in + or
-,
unless the name also contains at least one of these characters:
.sp
.nf
~ ! @ # % ^ & | ` ?
.sp
.fi
For example, @- is an allowed operator name,
but *- is not.
This restriction allows PostgreSQL to
parse SQL-compliant commands without requiring spaces between tokens.
.PP
.PP
The operator != is mapped to
<> on input, so these two names are always
equivalent.
.PP
At least one of LEFTARG and RIGHTARG must be defined. For
binary operators, both must be defined. For right unary
operators, only LEFTARG should be defined, while for left
unary operators only RIGHTARG should be defined.
.PP
The \fIfuncname\fR
procedure must have been previously defined using \fBCREATE
FUNCTION\fR and must be defined to accept the correct number
of arguments (either one or two) of the indicated types.
.PP
The other clauses specify optional operator optimization clauses.
Their meaning is detailed in in the documentation.
.SH "PARAMETERS"
.TP
\fB\fIname\fB\fR
The name of the operator to be defined. See above for allowable
characters. The name may be schema-qualified, for example
CREATE OPERATOR myschema.+ (...). If not, then
the operator is created in the current schema. Two operators
in the same schema can have the same name if they operate on
different data types. This is called
\fIoverloading\fR.
.TP
\fB\fIfuncname\fB\fR
The function used to implement this operator.
.TP
\fB\fIlefttype\fB\fR
The data type of the operator's left operand, if any.
This option would be omitted for a left-unary operator.
.TP
\fB\fIrighttype\fB\fR
The data type of the operator's right operand, if any.
This option would be omitted for a right-unary operator.
.TP
\fB\fIcom_op\fB\fR
The commutator of this operator.
.TP
\fB\fIneg_op\fB\fR
The negator of this operator.
.TP
\fB\fIres_proc\fB\fR
The restriction selectivity estimator function for this operator.
.TP
\fB\fIjoin_proc\fB\fR
The join selectivity estimator function for this operator.
.TP
\fBHASHES\fR
Indicates this operator can support a hash join.
.TP
\fBMERGES\fR
Indicates this operator can support a merge join.
.TP
\fB\fIleft_sort_op\fB\fR
If this operator can support a merge join, the less-than
operator that sorts the left-hand data type of this operator.
.TP
\fB\fIright_sort_op\fB\fR
If this operator can support a merge join, the less-than
operator that sorts the right-hand data type of this operator.
.TP
\fB\fIless_than_op\fB\fR
If this operator can support a merge join, the less-than
operator that compares the input data types of this operator.
.TP
\fB\fIgreater_than_op\fB\fR
If this operator can support a merge join, the greater-than
operator that compares the input data types of this operator.
.PP
To give a schema-qualified operator name in \fIcom_op\fR or the other optional
arguments, use the OPERATOR() syntax, for example
.sp
.nf
COMMUTATOR = OPERATOR(myschema.===) ,
.sp
.fi
.PP
.SH "NOTES"
.PP
Refer to in the documentation for further information.
.PP
Use DROP OPERATOR [\fBdrop_operator\fR(l)] to delete user-defined operators
from a database. Use ALTER OPERATOR [\fBalter_operator\fR(l)] to modify operators in a
database.
.SH "EXAMPLES"
.PP
The following command defines a new operator, area-equality, for
the data type \fBbox\fR:
.sp
.nf
CREATE OPERATOR === (
    LEFTARG = box,
    RIGHTARG = box,
    PROCEDURE = area_equal_procedure,
    COMMUTATOR = ===,
    NEGATOR = !==,
    RESTRICT = area_restriction_procedure,
    JOIN = area_join_procedure,
    HASHES,
    SORT1 = <<<,
    SORT2 = <<<
    -- Since sort operators were given, MERGES is implied.
    -- LTCMP and GTCMP are assumed to be < and > respectively
);
.sp
.fi
.SH "COMPATIBILITY"
.PP
\fBCREATE OPERATOR\fR is a
PostgreSQL extension. There are no
provisions for user-defined operators in the SQL standard.
.SH "SEE ALSO"
ALTER OPERATOR [\fBalter_operator\fR(l)], CREATE OPERATOR CLASS [\fBcreate_operator_class\fR(l)], DROP OPERATOR [\fBdrop_operator\fR(l)]
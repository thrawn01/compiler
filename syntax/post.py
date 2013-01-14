from api.lib.base import *

class Struct(object):
    def __init__(self, **attrs):
        for name,value in attrs.items():
            setattr( self, name, value)

    def __getattribute__(self, attr):
        "resolved for things that DO exist in the .__dict__"
        return object.__getattribute__(self, attr)

    def __getattr__(self, attr):
        "resolve for things do DO NOT exist in the .__dict__"
        if attr in self.__dict__:
            return self.__dict__[attr]
        return None

class Post(Struct):
    
    def __init__( self, params ):
        # Pass all the params from the post 
        # into the Struct constructor
        result = {}
        for key in params.keys():
            result[key] = params.get(key)

        Struct.__init__(self, **result )

    def toList( self ):
        return list(self.__dict__)
        
    def __iter__( self, key):
        return self.__dict__
    
    def __getitem__( self, key):
        return self.__dict__[key]

    def get( self, key, default ):
       
        # If the key does not exist
        if not key in self.__dict__:
            return default

        result = self.__dict__[key]
        # It may exist, but still be empty
        if result == "":
            return default

        return result

    def _missing(self, attr_list ):
        missing = []
        for attr in attr_list:
            if not attr in self.__dict__:
                missing.append( attr )

        if len(missing):
            abort(400, "POST fields are missing (%s) " % ",".join(missing) )
    
    def _empty(self, attr_list ):
        empty = []
        for attr in attr_list:
            content = self.__dict__[attr].strip(' ')
            if content == "":
                empty.append( attr )

        if len(empty):
            abort(400, "POST fields are empty (%s) " % ",".join(empty) )
        
    def required( self, attr_list ):
        # Are any of the required fields missing?
        self._missing(attr_list)
        # Are any empty?
        self._empty(attr_list)

    def allowed( self, attr_list ):
        for value in self.__dict__:
            if not value in attr_list:
                abort(400, "Parameter '%s' is not allowed, Acceptabled parameters are (%s) " % \
                    (value, ",".join(attr_list) ) )
                
    def validate( self, attr, values ):

        # Ignore attributes that don't exist in the post
        # Use Post.required() for this
        if not attr in self.__dict__:
            return True

        # For each of the authorized values
        for value in values:
            # If any value matches the key
            if self.__dict__[attr] == value:
                return True
        abort(400, "Invalid %s='%s' Acceptable values are (%s) " % \
                (attr, self.__dict__[attr], ",".join(values) ) )
        return False

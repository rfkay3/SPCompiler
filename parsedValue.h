class ParsedValue {
public:
    ParsedValue(const char * unboundValue, const char * unboundType);
    char * getValue();
    char * getType();
private:
    const char * value;
    const char * type;
};
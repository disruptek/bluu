
import
  json, options, hashes, uri, rest, os, uri, httpcore

## auto-generated via openapi macro
## title: DataLakeStoreAccountManagementClient
## version: 2015-10-01-preview
## termsOfService: (not provided)
## license: (not provided)
## 
## Creates an Azure Data Lake Store account management client.
## 
type
  Scheme {.pure.} = enum
    Https = "https", Http = "http", Wss = "wss", Ws = "ws"
  ValidatorSignature = proc (query: JsonNode = nil; body: JsonNode = nil;
                          header: JsonNode = nil; path: JsonNode = nil;
                          formData: JsonNode = nil): JsonNode
  OpenApiRestCall = ref object of RestCall
    validator*: ValidatorSignature
    route*: string
    base*: string
    host*: string
    schemes*: set[Scheme]
    url*: proc (protocol: Scheme; host: string; base: string; route: string;
              path: JsonNode; query: JsonNode): Uri

  OpenApiRestCall_563539 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_563539](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_563539): Option[Scheme] {.used.} =
  ## select a supported scheme from a set of candidates
  for scheme in Scheme.low ..
      Scheme.high:
    if scheme notin t.schemes:
      continue
    if scheme in [Scheme.Https, Scheme.Wss]:
      when defined(ssl):
        return some(scheme)
      else:
        continue
    return some(scheme)

proc validateParameter(js: JsonNode; kind: JsonNodeKind; required: bool;
                      default: JsonNode = nil): JsonNode =
  ## ensure an input is of the correct json type and yield
  ## a suitable default value when appropriate
  if js ==
      nil:
    if default != nil:
      return validateParameter(default, kind, required = required)
  result = js
  if result ==
      nil:
    assert not required, $kind & " expected; received nil"
    if required:
      result = newJNull()
  else:
    assert js.kind ==
        kind, $kind & " expected; received " &
        $js.kind

type
  KeyVal {.used.} = tuple[key: string, val: string]
  PathTokenKind = enum
    ConstantSegment, VariableSegment
  PathToken = tuple[kind: PathTokenKind, value: string]
proc queryString(query: JsonNode): string {.used.} =
  var qs: seq[KeyVal]
  if query == nil:
    return ""
  for k, v in query.pairs:
    qs.add (key: k, val: v.getStr)
  result = encodeQuery(qs)

proc hydratePath(input: JsonNode; segments: seq[PathToken]): Option[string] {.used.} =
  ## reconstitute a path with constants and variable values taken from json
  var head: string
  if segments.len == 0:
    return some("")
  head = segments[0].value
  case segments[0].kind
  of ConstantSegment:
    discard
  of VariableSegment:
    if head notin input:
      return
    let js = input[head]
    case js.kind
    of JInt, JFloat, JNull, JBool:
      head = $js
    of JString:
      head = js.getStr
    else:
      return
  var remainder = input.hydratePath(segments[1 ..^ 1])
  if remainder.isNone:
    return
  result = some(head & remainder.get)

const
  macServiceName = "datalake-store-account"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_AccountList_563761 = ref object of OpenApiRestCall_563539
proc url_AccountList_563763(protocol: Scheme; host: string; base: string;
                           route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.DataLakeStore/accounts")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AccountList_563762(path: JsonNode; query: JsonNode; header: JsonNode;
                                formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists the Data Lake Store accounts within the subscription. The response includes a link to the next page of results, if any.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_563939 = path.getOrDefault("subscriptionId")
  valid_563939 = validateParameter(valid_563939, JString, required = true,
                                 default = nil)
  if valid_563939 != nil:
    section.add "subscriptionId", valid_563939
  result.add "path", section
  ## parameters in `query` object:
  ##   $top: JInt
  ##       : The number of items to return. Optional.
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   $select: JString
  ##          : OData Select statement. Limits the properties on each entry to just those requested, e.g. Categories?$select=CategoryName,Description. Optional.
  ##   $expand: JString
  ##          : OData expansion. Expand related resources in line with the retrieved resources, e.g. Categories/$expand=Products would expand Product data in line with each Category entry. Optional.
  ##   $count: JBool
  ##         : The Boolean value of true or false to request a count of the matching resources included with the resources in the response, e.g. Categories?$count=true. Optional.
  ##   $format: JString
  ##          : The desired return format. Return the response in particular format without access to request headers for standard content-type negotiation (e.g Orders?$format=json). Optional.
  ##   $orderby: JString
  ##           : OrderBy clause. One or more comma-separated expressions with an optional "asc" (the default) or "desc" depending on the order you'd like the values sorted, e.g. Categories?$orderby=CategoryName desc. Optional.
  ##   $skip: JInt
  ##        : The number of items to skip over before returning elements. Optional.
  ##   $filter: JString
  ##          : OData filter. Optional.
  ##   $search: JString
  ##          : A free form search. A free-text search expression to match for whether a particular entry should be included in the feed, e.g. Categories?$search=blue OR green. Optional.
  section = newJObject()
  var valid_563940 = query.getOrDefault("$top")
  valid_563940 = validateParameter(valid_563940, JInt, required = false, default = nil)
  if valid_563940 != nil:
    section.add "$top", valid_563940
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_563941 = query.getOrDefault("api-version")
  valid_563941 = validateParameter(valid_563941, JString, required = true,
                                 default = nil)
  if valid_563941 != nil:
    section.add "api-version", valid_563941
  var valid_563942 = query.getOrDefault("$select")
  valid_563942 = validateParameter(valid_563942, JString, required = false,
                                 default = nil)
  if valid_563942 != nil:
    section.add "$select", valid_563942
  var valid_563943 = query.getOrDefault("$expand")
  valid_563943 = validateParameter(valid_563943, JString, required = false,
                                 default = nil)
  if valid_563943 != nil:
    section.add "$expand", valid_563943
  var valid_563944 = query.getOrDefault("$count")
  valid_563944 = validateParameter(valid_563944, JBool, required = false, default = nil)
  if valid_563944 != nil:
    section.add "$count", valid_563944
  var valid_563945 = query.getOrDefault("$format")
  valid_563945 = validateParameter(valid_563945, JString, required = false,
                                 default = nil)
  if valid_563945 != nil:
    section.add "$format", valid_563945
  var valid_563946 = query.getOrDefault("$orderby")
  valid_563946 = validateParameter(valid_563946, JString, required = false,
                                 default = nil)
  if valid_563946 != nil:
    section.add "$orderby", valid_563946
  var valid_563947 = query.getOrDefault("$skip")
  valid_563947 = validateParameter(valid_563947, JInt, required = false, default = nil)
  if valid_563947 != nil:
    section.add "$skip", valid_563947
  var valid_563948 = query.getOrDefault("$filter")
  valid_563948 = validateParameter(valid_563948, JString, required = false,
                                 default = nil)
  if valid_563948 != nil:
    section.add "$filter", valid_563948
  var valid_563949 = query.getOrDefault("$search")
  valid_563949 = validateParameter(valid_563949, JString, required = false,
                                 default = nil)
  if valid_563949 != nil:
    section.add "$search", valid_563949
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_563972: Call_AccountList_563761; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the Data Lake Store accounts within the subscription. The response includes a link to the next page of results, if any.
  ## 
  let valid = call_563972.validator(path, query, header, formData, body)
  let scheme = call_563972.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_563972.url(scheme.get, call_563972.host, call_563972.base,
                         call_563972.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_563972, url, valid)

proc call*(call_564043: Call_AccountList_563761; apiVersion: string;
          subscriptionId: string; Top: int = 0; Select: string = ""; Expand: string = "";
          Count: bool = false; Format: string = ""; Orderby: string = ""; Skip: int = 0;
          Filter: string = ""; Search: string = ""): Recallable =
  ## accountList
  ## Lists the Data Lake Store accounts within the subscription. The response includes a link to the next page of results, if any.
  ##   Top: int
  ##      : The number of items to return. Optional.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   Select: string
  ##         : OData Select statement. Limits the properties on each entry to just those requested, e.g. Categories?$select=CategoryName,Description. Optional.
  ##   Expand: string
  ##         : OData expansion. Expand related resources in line with the retrieved resources, e.g. Categories/$expand=Products would expand Product data in line with each Category entry. Optional.
  ##   Count: bool
  ##        : The Boolean value of true or false to request a count of the matching resources included with the resources in the response, e.g. Categories?$count=true. Optional.
  ##   Format: string
  ##         : The desired return format. Return the response in particular format without access to request headers for standard content-type negotiation (e.g Orders?$format=json). Optional.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   Orderby: string
  ##          : OrderBy clause. One or more comma-separated expressions with an optional "asc" (the default) or "desc" depending on the order you'd like the values sorted, e.g. Categories?$orderby=CategoryName desc. Optional.
  ##   Skip: int
  ##       : The number of items to skip over before returning elements. Optional.
  ##   Filter: string
  ##         : OData filter. Optional.
  ##   Search: string
  ##         : A free form search. A free-text search expression to match for whether a particular entry should be included in the feed, e.g. Categories?$search=blue OR green. Optional.
  var path_564044 = newJObject()
  var query_564046 = newJObject()
  add(query_564046, "$top", newJInt(Top))
  add(query_564046, "api-version", newJString(apiVersion))
  add(query_564046, "$select", newJString(Select))
  add(query_564046, "$expand", newJString(Expand))
  add(query_564046, "$count", newJBool(Count))
  add(query_564046, "$format", newJString(Format))
  add(path_564044, "subscriptionId", newJString(subscriptionId))
  add(query_564046, "$orderby", newJString(Orderby))
  add(query_564046, "$skip", newJInt(Skip))
  add(query_564046, "$filter", newJString(Filter))
  add(query_564046, "$search", newJString(Search))
  result = call_564043.call(path_564044, query_564046, nil, nil, nil)

var accountList* = Call_AccountList_563761(name: "accountList",
                                        meth: HttpMethod.HttpGet,
                                        host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.DataLakeStore/accounts",
                                        validator: validate_AccountList_563762,
                                        base: "", url: url_AccountList_563763,
                                        schemes: {Scheme.Https})
type
  Call_AccountListByResourceGroup_564085 = ref object of OpenApiRestCall_563539
proc url_AccountListByResourceGroup_564087(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.DataLakeStore/accounts")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AccountListByResourceGroup_564086(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists the Data Lake Store accounts within a specific resource group. The response includes a link to the next page of results, if any.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the Azure resource group that contains the Data Lake Store account(s).
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564088 = path.getOrDefault("subscriptionId")
  valid_564088 = validateParameter(valid_564088, JString, required = true,
                                 default = nil)
  if valid_564088 != nil:
    section.add "subscriptionId", valid_564088
  var valid_564089 = path.getOrDefault("resourceGroupName")
  valid_564089 = validateParameter(valid_564089, JString, required = true,
                                 default = nil)
  if valid_564089 != nil:
    section.add "resourceGroupName", valid_564089
  result.add "path", section
  ## parameters in `query` object:
  ##   $top: JInt
  ##       : The number of items to return. Optional.
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   $select: JString
  ##          : OData Select statement. Limits the properties on each entry to just those requested, e.g. Categories?$select=CategoryName,Description. Optional.
  ##   $expand: JString
  ##          : OData expansion. Expand related resources in line with the retrieved resources, e.g. Categories/$expand=Products would expand Product data in line with each Category entry. Optional.
  ##   $count: JBool
  ##         : A Boolean value of true or false to request a count of the matching resources included with the resources in the response, e.g. Categories?$count=true. Optional.
  ##   $format: JString
  ##          : The desired return format. Return the response in particular format without access to request headers for standard content-type negotiation (e.g Orders?$format=json). Optional.
  ##   $orderby: JString
  ##           : OrderBy clause. One or more comma-separated expressions with an optional "asc" (the default) or "desc" depending on the order you'd like the values sorted, e.g. Categories?$orderby=CategoryName desc. Optional.
  ##   $skip: JInt
  ##        : The number of items to skip over before returning elements. Optional.
  ##   $filter: JString
  ##          : OData filter. Optional.
  ##   $search: JString
  ##          : A free form search. A free-text search expression to match for whether a particular entry should be included in the feed, e.g. Categories?$search=blue OR green. Optional.
  section = newJObject()
  var valid_564090 = query.getOrDefault("$top")
  valid_564090 = validateParameter(valid_564090, JInt, required = false, default = nil)
  if valid_564090 != nil:
    section.add "$top", valid_564090
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564091 = query.getOrDefault("api-version")
  valid_564091 = validateParameter(valid_564091, JString, required = true,
                                 default = nil)
  if valid_564091 != nil:
    section.add "api-version", valid_564091
  var valid_564092 = query.getOrDefault("$select")
  valid_564092 = validateParameter(valid_564092, JString, required = false,
                                 default = nil)
  if valid_564092 != nil:
    section.add "$select", valid_564092
  var valid_564093 = query.getOrDefault("$expand")
  valid_564093 = validateParameter(valid_564093, JString, required = false,
                                 default = nil)
  if valid_564093 != nil:
    section.add "$expand", valid_564093
  var valid_564094 = query.getOrDefault("$count")
  valid_564094 = validateParameter(valid_564094, JBool, required = false, default = nil)
  if valid_564094 != nil:
    section.add "$count", valid_564094
  var valid_564095 = query.getOrDefault("$format")
  valid_564095 = validateParameter(valid_564095, JString, required = false,
                                 default = nil)
  if valid_564095 != nil:
    section.add "$format", valid_564095
  var valid_564096 = query.getOrDefault("$orderby")
  valid_564096 = validateParameter(valid_564096, JString, required = false,
                                 default = nil)
  if valid_564096 != nil:
    section.add "$orderby", valid_564096
  var valid_564097 = query.getOrDefault("$skip")
  valid_564097 = validateParameter(valid_564097, JInt, required = false, default = nil)
  if valid_564097 != nil:
    section.add "$skip", valid_564097
  var valid_564098 = query.getOrDefault("$filter")
  valid_564098 = validateParameter(valid_564098, JString, required = false,
                                 default = nil)
  if valid_564098 != nil:
    section.add "$filter", valid_564098
  var valid_564099 = query.getOrDefault("$search")
  valid_564099 = validateParameter(valid_564099, JString, required = false,
                                 default = nil)
  if valid_564099 != nil:
    section.add "$search", valid_564099
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564100: Call_AccountListByResourceGroup_564085; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the Data Lake Store accounts within a specific resource group. The response includes a link to the next page of results, if any.
  ## 
  let valid = call_564100.validator(path, query, header, formData, body)
  let scheme = call_564100.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564100.url(scheme.get, call_564100.host, call_564100.base,
                         call_564100.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564100, url, valid)

proc call*(call_564101: Call_AccountListByResourceGroup_564085; apiVersion: string;
          subscriptionId: string; resourceGroupName: string; Top: int = 0;
          Select: string = ""; Expand: string = ""; Count: bool = false;
          Format: string = ""; Orderby: string = ""; Skip: int = 0; Filter: string = "";
          Search: string = ""): Recallable =
  ## accountListByResourceGroup
  ## Lists the Data Lake Store accounts within a specific resource group. The response includes a link to the next page of results, if any.
  ##   Top: int
  ##      : The number of items to return. Optional.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   Select: string
  ##         : OData Select statement. Limits the properties on each entry to just those requested, e.g. Categories?$select=CategoryName,Description. Optional.
  ##   Expand: string
  ##         : OData expansion. Expand related resources in line with the retrieved resources, e.g. Categories/$expand=Products would expand Product data in line with each Category entry. Optional.
  ##   Count: bool
  ##        : A Boolean value of true or false to request a count of the matching resources included with the resources in the response, e.g. Categories?$count=true. Optional.
  ##   Format: string
  ##         : The desired return format. Return the response in particular format without access to request headers for standard content-type negotiation (e.g Orders?$format=json). Optional.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   Orderby: string
  ##          : OrderBy clause. One or more comma-separated expressions with an optional "asc" (the default) or "desc" depending on the order you'd like the values sorted, e.g. Categories?$orderby=CategoryName desc. Optional.
  ##   Skip: int
  ##       : The number of items to skip over before returning elements. Optional.
  ##   resourceGroupName: string (required)
  ##                    : The name of the Azure resource group that contains the Data Lake Store account(s).
  ##   Filter: string
  ##         : OData filter. Optional.
  ##   Search: string
  ##         : A free form search. A free-text search expression to match for whether a particular entry should be included in the feed, e.g. Categories?$search=blue OR green. Optional.
  var path_564102 = newJObject()
  var query_564103 = newJObject()
  add(query_564103, "$top", newJInt(Top))
  add(query_564103, "api-version", newJString(apiVersion))
  add(query_564103, "$select", newJString(Select))
  add(query_564103, "$expand", newJString(Expand))
  add(query_564103, "$count", newJBool(Count))
  add(query_564103, "$format", newJString(Format))
  add(path_564102, "subscriptionId", newJString(subscriptionId))
  add(query_564103, "$orderby", newJString(Orderby))
  add(query_564103, "$skip", newJInt(Skip))
  add(path_564102, "resourceGroupName", newJString(resourceGroupName))
  add(query_564103, "$filter", newJString(Filter))
  add(query_564103, "$search", newJString(Search))
  result = call_564101.call(path_564102, query_564103, nil, nil, nil)

var accountListByResourceGroup* = Call_AccountListByResourceGroup_564085(
    name: "accountListByResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataLakeStore/accounts",
    validator: validate_AccountListByResourceGroup_564086, base: "",
    url: url_AccountListByResourceGroup_564087, schemes: {Scheme.Https})
type
  Call_AccountGet_564104 = ref object of OpenApiRestCall_563539
proc url_AccountGet_564106(protocol: Scheme; host: string; base: string; route: string;
                          path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "accountName" in path, "`accountName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.DataLakeStore/accounts/"),
               (kind: VariableSegment, value: "accountName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AccountGet_564105(path: JsonNode; query: JsonNode; header: JsonNode;
                               formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the specified Data Lake Store account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the Azure resource group that contains the Data Lake Store account.
  ##   accountName: JString (required)
  ##              : The name of the Data Lake Store account to retrieve.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564107 = path.getOrDefault("subscriptionId")
  valid_564107 = validateParameter(valid_564107, JString, required = true,
                                 default = nil)
  if valid_564107 != nil:
    section.add "subscriptionId", valid_564107
  var valid_564108 = path.getOrDefault("resourceGroupName")
  valid_564108 = validateParameter(valid_564108, JString, required = true,
                                 default = nil)
  if valid_564108 != nil:
    section.add "resourceGroupName", valid_564108
  var valid_564109 = path.getOrDefault("accountName")
  valid_564109 = validateParameter(valid_564109, JString, required = true,
                                 default = nil)
  if valid_564109 != nil:
    section.add "accountName", valid_564109
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564110 = query.getOrDefault("api-version")
  valid_564110 = validateParameter(valid_564110, JString, required = true,
                                 default = nil)
  if valid_564110 != nil:
    section.add "api-version", valid_564110
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564111: Call_AccountGet_564104; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the specified Data Lake Store account.
  ## 
  let valid = call_564111.validator(path, query, header, formData, body)
  let scheme = call_564111.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564111.url(scheme.get, call_564111.host, call_564111.base,
                         call_564111.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564111, url, valid)

proc call*(call_564112: Call_AccountGet_564104; apiVersion: string;
          subscriptionId: string; resourceGroupName: string; accountName: string): Recallable =
  ## accountGet
  ## Gets the specified Data Lake Store account.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the Azure resource group that contains the Data Lake Store account.
  ##   accountName: string (required)
  ##              : The name of the Data Lake Store account to retrieve.
  var path_564113 = newJObject()
  var query_564114 = newJObject()
  add(query_564114, "api-version", newJString(apiVersion))
  add(path_564113, "subscriptionId", newJString(subscriptionId))
  add(path_564113, "resourceGroupName", newJString(resourceGroupName))
  add(path_564113, "accountName", newJString(accountName))
  result = call_564112.call(path_564113, query_564114, nil, nil, nil)

var accountGet* = Call_AccountGet_564104(name: "accountGet",
                                      meth: HttpMethod.HttpGet,
                                      host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataLakeStore/accounts/{accountName}",
                                      validator: validate_AccountGet_564105,
                                      base: "", url: url_AccountGet_564106,
                                      schemes: {Scheme.Https})
type
  Call_AccountDelete_564115 = ref object of OpenApiRestCall_563539
proc url_AccountDelete_564117(protocol: Scheme; host: string; base: string;
                             route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "accountName" in path, "`accountName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.DataLakeStore/accounts/"),
               (kind: VariableSegment, value: "accountName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AccountDelete_564116(path: JsonNode; query: JsonNode; header: JsonNode;
                                  formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes the specified Data Lake Store account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the Azure resource group that contains the Data Lake Store account.
  ##   accountName: JString (required)
  ##              : The name of the Data Lake Store account to delete.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564118 = path.getOrDefault("subscriptionId")
  valid_564118 = validateParameter(valid_564118, JString, required = true,
                                 default = nil)
  if valid_564118 != nil:
    section.add "subscriptionId", valid_564118
  var valid_564119 = path.getOrDefault("resourceGroupName")
  valid_564119 = validateParameter(valid_564119, JString, required = true,
                                 default = nil)
  if valid_564119 != nil:
    section.add "resourceGroupName", valid_564119
  var valid_564120 = path.getOrDefault("accountName")
  valid_564120 = validateParameter(valid_564120, JString, required = true,
                                 default = nil)
  if valid_564120 != nil:
    section.add "accountName", valid_564120
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564121 = query.getOrDefault("api-version")
  valid_564121 = validateParameter(valid_564121, JString, required = true,
                                 default = nil)
  if valid_564121 != nil:
    section.add "api-version", valid_564121
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564122: Call_AccountDelete_564115; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the specified Data Lake Store account.
  ## 
  let valid = call_564122.validator(path, query, header, formData, body)
  let scheme = call_564122.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564122.url(scheme.get, call_564122.host, call_564122.base,
                         call_564122.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564122, url, valid)

proc call*(call_564123: Call_AccountDelete_564115; apiVersion: string;
          subscriptionId: string; resourceGroupName: string; accountName: string): Recallable =
  ## accountDelete
  ## Deletes the specified Data Lake Store account.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the Azure resource group that contains the Data Lake Store account.
  ##   accountName: string (required)
  ##              : The name of the Data Lake Store account to delete.
  var path_564124 = newJObject()
  var query_564125 = newJObject()
  add(query_564125, "api-version", newJString(apiVersion))
  add(path_564124, "subscriptionId", newJString(subscriptionId))
  add(path_564124, "resourceGroupName", newJString(resourceGroupName))
  add(path_564124, "accountName", newJString(accountName))
  result = call_564123.call(path_564124, query_564125, nil, nil, nil)

var accountDelete* = Call_AccountDelete_564115(name: "accountDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataLakeStore/accounts/{accountName}",
    validator: validate_AccountDelete_564116, base: "", url: url_AccountDelete_564117,
    schemes: {Scheme.Https})
type
  Call_AccountEnableKeyVault_564126 = ref object of OpenApiRestCall_563539
proc url_AccountEnableKeyVault_564128(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "accountName" in path, "`accountName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.DataLakeStore/accounts/"),
               (kind: VariableSegment, value: "accountName"),
               (kind: ConstantSegment, value: "/enableKeyVault")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AccountEnableKeyVault_564127(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Attempts to enable a user managed key vault for encryption of the specified Data Lake Store account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the Azure resource group that contains the Data Lake Store account.
  ##   accountName: JString (required)
  ##              : The name of the Data Lake Store account to attempt to enable the Key Vault for.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564129 = path.getOrDefault("subscriptionId")
  valid_564129 = validateParameter(valid_564129, JString, required = true,
                                 default = nil)
  if valid_564129 != nil:
    section.add "subscriptionId", valid_564129
  var valid_564130 = path.getOrDefault("resourceGroupName")
  valid_564130 = validateParameter(valid_564130, JString, required = true,
                                 default = nil)
  if valid_564130 != nil:
    section.add "resourceGroupName", valid_564130
  var valid_564131 = path.getOrDefault("accountName")
  valid_564131 = validateParameter(valid_564131, JString, required = true,
                                 default = nil)
  if valid_564131 != nil:
    section.add "accountName", valid_564131
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564132 = query.getOrDefault("api-version")
  valid_564132 = validateParameter(valid_564132, JString, required = true,
                                 default = nil)
  if valid_564132 != nil:
    section.add "api-version", valid_564132
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564133: Call_AccountEnableKeyVault_564126; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Attempts to enable a user managed key vault for encryption of the specified Data Lake Store account.
  ## 
  let valid = call_564133.validator(path, query, header, formData, body)
  let scheme = call_564133.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564133.url(scheme.get, call_564133.host, call_564133.base,
                         call_564133.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564133, url, valid)

proc call*(call_564134: Call_AccountEnableKeyVault_564126; apiVersion: string;
          subscriptionId: string; resourceGroupName: string; accountName: string): Recallable =
  ## accountEnableKeyVault
  ## Attempts to enable a user managed key vault for encryption of the specified Data Lake Store account.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the Azure resource group that contains the Data Lake Store account.
  ##   accountName: string (required)
  ##              : The name of the Data Lake Store account to attempt to enable the Key Vault for.
  var path_564135 = newJObject()
  var query_564136 = newJObject()
  add(query_564136, "api-version", newJString(apiVersion))
  add(path_564135, "subscriptionId", newJString(subscriptionId))
  add(path_564135, "resourceGroupName", newJString(resourceGroupName))
  add(path_564135, "accountName", newJString(accountName))
  result = call_564134.call(path_564135, query_564136, nil, nil, nil)

var accountEnableKeyVault* = Call_AccountEnableKeyVault_564126(
    name: "accountEnableKeyVault", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataLakeStore/accounts/{accountName}/enableKeyVault",
    validator: validate_AccountEnableKeyVault_564127, base: "",
    url: url_AccountEnableKeyVault_564128, schemes: {Scheme.Https})
type
  Call_AccountListFirewallRules_564137 = ref object of OpenApiRestCall_563539
proc url_AccountListFirewallRules_564139(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "accountName" in path, "`accountName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.DataLakeStore/accounts/"),
               (kind: VariableSegment, value: "accountName"),
               (kind: ConstantSegment, value: "/firewallRules")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AccountListFirewallRules_564138(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists the Data Lake Store firewall rules within the specified Data Lake Store account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the Azure resource group that contains the Data Lake Store account.
  ##   accountName: JString (required)
  ##              : The name of the Data Lake Store account from which to get the firewall rules.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564140 = path.getOrDefault("subscriptionId")
  valid_564140 = validateParameter(valid_564140, JString, required = true,
                                 default = nil)
  if valid_564140 != nil:
    section.add "subscriptionId", valid_564140
  var valid_564141 = path.getOrDefault("resourceGroupName")
  valid_564141 = validateParameter(valid_564141, JString, required = true,
                                 default = nil)
  if valid_564141 != nil:
    section.add "resourceGroupName", valid_564141
  var valid_564142 = path.getOrDefault("accountName")
  valid_564142 = validateParameter(valid_564142, JString, required = true,
                                 default = nil)
  if valid_564142 != nil:
    section.add "accountName", valid_564142
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564143 = query.getOrDefault("api-version")
  valid_564143 = validateParameter(valid_564143, JString, required = true,
                                 default = nil)
  if valid_564143 != nil:
    section.add "api-version", valid_564143
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564144: Call_AccountListFirewallRules_564137; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the Data Lake Store firewall rules within the specified Data Lake Store account.
  ## 
  let valid = call_564144.validator(path, query, header, formData, body)
  let scheme = call_564144.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564144.url(scheme.get, call_564144.host, call_564144.base,
                         call_564144.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564144, url, valid)

proc call*(call_564145: Call_AccountListFirewallRules_564137; apiVersion: string;
          subscriptionId: string; resourceGroupName: string; accountName: string): Recallable =
  ## accountListFirewallRules
  ## Lists the Data Lake Store firewall rules within the specified Data Lake Store account.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the Azure resource group that contains the Data Lake Store account.
  ##   accountName: string (required)
  ##              : The name of the Data Lake Store account from which to get the firewall rules.
  var path_564146 = newJObject()
  var query_564147 = newJObject()
  add(query_564147, "api-version", newJString(apiVersion))
  add(path_564146, "subscriptionId", newJString(subscriptionId))
  add(path_564146, "resourceGroupName", newJString(resourceGroupName))
  add(path_564146, "accountName", newJString(accountName))
  result = call_564145.call(path_564146, query_564147, nil, nil, nil)

var accountListFirewallRules* = Call_AccountListFirewallRules_564137(
    name: "accountListFirewallRules", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataLakeStore/accounts/{accountName}/firewallRules",
    validator: validate_AccountListFirewallRules_564138, base: "",
    url: url_AccountListFirewallRules_564139, schemes: {Scheme.Https})
type
  Call_AccountGetFirewallRule_564148 = ref object of OpenApiRestCall_563539
proc url_AccountGetFirewallRule_564150(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "accountName" in path, "`accountName` is a required path parameter"
  assert "firewallRuleName" in path,
        "`firewallRuleName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.DataLakeStore/accounts/"),
               (kind: VariableSegment, value: "accountName"),
               (kind: ConstantSegment, value: "/firewallRules/"),
               (kind: VariableSegment, value: "firewallRuleName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AccountGetFirewallRule_564149(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the specified Data Lake Store firewall rule.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   firewallRuleName: JString (required)
  ##                   : The name of the firewall rule to retrieve.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the Azure resource group that contains the Data Lake Store account.
  ##   accountName: JString (required)
  ##              : The name of the Data Lake Store account from which to get the firewall rule.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `firewallRuleName` field"
  var valid_564151 = path.getOrDefault("firewallRuleName")
  valid_564151 = validateParameter(valid_564151, JString, required = true,
                                 default = nil)
  if valid_564151 != nil:
    section.add "firewallRuleName", valid_564151
  var valid_564152 = path.getOrDefault("subscriptionId")
  valid_564152 = validateParameter(valid_564152, JString, required = true,
                                 default = nil)
  if valid_564152 != nil:
    section.add "subscriptionId", valid_564152
  var valid_564153 = path.getOrDefault("resourceGroupName")
  valid_564153 = validateParameter(valid_564153, JString, required = true,
                                 default = nil)
  if valid_564153 != nil:
    section.add "resourceGroupName", valid_564153
  var valid_564154 = path.getOrDefault("accountName")
  valid_564154 = validateParameter(valid_564154, JString, required = true,
                                 default = nil)
  if valid_564154 != nil:
    section.add "accountName", valid_564154
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564155 = query.getOrDefault("api-version")
  valid_564155 = validateParameter(valid_564155, JString, required = true,
                                 default = nil)
  if valid_564155 != nil:
    section.add "api-version", valid_564155
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564156: Call_AccountGetFirewallRule_564148; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the specified Data Lake Store firewall rule.
  ## 
  let valid = call_564156.validator(path, query, header, formData, body)
  let scheme = call_564156.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564156.url(scheme.get, call_564156.host, call_564156.base,
                         call_564156.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564156, url, valid)

proc call*(call_564157: Call_AccountGetFirewallRule_564148; apiVersion: string;
          firewallRuleName: string; subscriptionId: string;
          resourceGroupName: string; accountName: string): Recallable =
  ## accountGetFirewallRule
  ## Gets the specified Data Lake Store firewall rule.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   firewallRuleName: string (required)
  ##                   : The name of the firewall rule to retrieve.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the Azure resource group that contains the Data Lake Store account.
  ##   accountName: string (required)
  ##              : The name of the Data Lake Store account from which to get the firewall rule.
  var path_564158 = newJObject()
  var query_564159 = newJObject()
  add(query_564159, "api-version", newJString(apiVersion))
  add(path_564158, "firewallRuleName", newJString(firewallRuleName))
  add(path_564158, "subscriptionId", newJString(subscriptionId))
  add(path_564158, "resourceGroupName", newJString(resourceGroupName))
  add(path_564158, "accountName", newJString(accountName))
  result = call_564157.call(path_564158, query_564159, nil, nil, nil)

var accountGetFirewallRule* = Call_AccountGetFirewallRule_564148(
    name: "accountGetFirewallRule", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataLakeStore/accounts/{accountName}/firewallRules/{firewallRuleName}",
    validator: validate_AccountGetFirewallRule_564149, base: "",
    url: url_AccountGetFirewallRule_564150, schemes: {Scheme.Https})
type
  Call_AccountDeleteFirewallRule_564160 = ref object of OpenApiRestCall_563539
proc url_AccountDeleteFirewallRule_564162(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "accountName" in path, "`accountName` is a required path parameter"
  assert "firewallRuleName" in path,
        "`firewallRuleName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.DataLakeStore/accounts/"),
               (kind: VariableSegment, value: "accountName"),
               (kind: ConstantSegment, value: "/firewallRules/"),
               (kind: VariableSegment, value: "firewallRuleName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AccountDeleteFirewallRule_564161(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes the specified firewall rule from the specified Data Lake Store account
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   firewallRuleName: JString (required)
  ##                   : The name of the firewall rule to delete.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the Azure resource group that contains the Data Lake Store account.
  ##   accountName: JString (required)
  ##              : The name of the Data Lake Store account from which to delete the firewall rule.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `firewallRuleName` field"
  var valid_564163 = path.getOrDefault("firewallRuleName")
  valid_564163 = validateParameter(valid_564163, JString, required = true,
                                 default = nil)
  if valid_564163 != nil:
    section.add "firewallRuleName", valid_564163
  var valid_564164 = path.getOrDefault("subscriptionId")
  valid_564164 = validateParameter(valid_564164, JString, required = true,
                                 default = nil)
  if valid_564164 != nil:
    section.add "subscriptionId", valid_564164
  var valid_564165 = path.getOrDefault("resourceGroupName")
  valid_564165 = validateParameter(valid_564165, JString, required = true,
                                 default = nil)
  if valid_564165 != nil:
    section.add "resourceGroupName", valid_564165
  var valid_564166 = path.getOrDefault("accountName")
  valid_564166 = validateParameter(valid_564166, JString, required = true,
                                 default = nil)
  if valid_564166 != nil:
    section.add "accountName", valid_564166
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564167 = query.getOrDefault("api-version")
  valid_564167 = validateParameter(valid_564167, JString, required = true,
                                 default = nil)
  if valid_564167 != nil:
    section.add "api-version", valid_564167
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564168: Call_AccountDeleteFirewallRule_564160; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the specified firewall rule from the specified Data Lake Store account
  ## 
  let valid = call_564168.validator(path, query, header, formData, body)
  let scheme = call_564168.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564168.url(scheme.get, call_564168.host, call_564168.base,
                         call_564168.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564168, url, valid)

proc call*(call_564169: Call_AccountDeleteFirewallRule_564160; apiVersion: string;
          firewallRuleName: string; subscriptionId: string;
          resourceGroupName: string; accountName: string): Recallable =
  ## accountDeleteFirewallRule
  ## Deletes the specified firewall rule from the specified Data Lake Store account
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   firewallRuleName: string (required)
  ##                   : The name of the firewall rule to delete.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the Azure resource group that contains the Data Lake Store account.
  ##   accountName: string (required)
  ##              : The name of the Data Lake Store account from which to delete the firewall rule.
  var path_564170 = newJObject()
  var query_564171 = newJObject()
  add(query_564171, "api-version", newJString(apiVersion))
  add(path_564170, "firewallRuleName", newJString(firewallRuleName))
  add(path_564170, "subscriptionId", newJString(subscriptionId))
  add(path_564170, "resourceGroupName", newJString(resourceGroupName))
  add(path_564170, "accountName", newJString(accountName))
  result = call_564169.call(path_564170, query_564171, nil, nil, nil)

var accountDeleteFirewallRule* = Call_AccountDeleteFirewallRule_564160(
    name: "accountDeleteFirewallRule", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataLakeStore/accounts/{accountName}/firewallRules/{firewallRuleName}",
    validator: validate_AccountDeleteFirewallRule_564161, base: "",
    url: url_AccountDeleteFirewallRule_564162, schemes: {Scheme.Https})
type
  Call_AccountCreateOrUpdateFirewallRule_564172 = ref object of OpenApiRestCall_563539
proc url_AccountCreateOrUpdateFirewallRule_564174(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "accountName" in path, "`accountName` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.DataLakeStore/accounts/"),
               (kind: VariableSegment, value: "accountName"),
               (kind: ConstantSegment, value: "/firewallRules/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AccountCreateOrUpdateFirewallRule_564173(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates or updates the specified firewall rule.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The name of the firewall rule to create or update.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the Azure resource group that contains the Data Lake Store account.
  ##   accountName: JString (required)
  ##              : The name of the Data Lake Store account to which to add the firewall rule.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_564192 = path.getOrDefault("name")
  valid_564192 = validateParameter(valid_564192, JString, required = true,
                                 default = nil)
  if valid_564192 != nil:
    section.add "name", valid_564192
  var valid_564193 = path.getOrDefault("subscriptionId")
  valid_564193 = validateParameter(valid_564193, JString, required = true,
                                 default = nil)
  if valid_564193 != nil:
    section.add "subscriptionId", valid_564193
  var valid_564194 = path.getOrDefault("resourceGroupName")
  valid_564194 = validateParameter(valid_564194, JString, required = true,
                                 default = nil)
  if valid_564194 != nil:
    section.add "resourceGroupName", valid_564194
  var valid_564195 = path.getOrDefault("accountName")
  valid_564195 = validateParameter(valid_564195, JString, required = true,
                                 default = nil)
  if valid_564195 != nil:
    section.add "accountName", valid_564195
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564196 = query.getOrDefault("api-version")
  valid_564196 = validateParameter(valid_564196, JString, required = true,
                                 default = nil)
  if valid_564196 != nil:
    section.add "api-version", valid_564196
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters supplied to create the create firewall rule.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564198: Call_AccountCreateOrUpdateFirewallRule_564172;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates or updates the specified firewall rule.
  ## 
  let valid = call_564198.validator(path, query, header, formData, body)
  let scheme = call_564198.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564198.url(scheme.get, call_564198.host, call_564198.base,
                         call_564198.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564198, url, valid)

proc call*(call_564199: Call_AccountCreateOrUpdateFirewallRule_564172;
          apiVersion: string; name: string; subscriptionId: string;
          resourceGroupName: string; parameters: JsonNode; accountName: string): Recallable =
  ## accountCreateOrUpdateFirewallRule
  ## Creates or updates the specified firewall rule.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   name: string (required)
  ##       : The name of the firewall rule to create or update.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the Azure resource group that contains the Data Lake Store account.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to create the create firewall rule.
  ##   accountName: string (required)
  ##              : The name of the Data Lake Store account to which to add the firewall rule.
  var path_564200 = newJObject()
  var query_564201 = newJObject()
  var body_564202 = newJObject()
  add(query_564201, "api-version", newJString(apiVersion))
  add(path_564200, "name", newJString(name))
  add(path_564200, "subscriptionId", newJString(subscriptionId))
  add(path_564200, "resourceGroupName", newJString(resourceGroupName))
  if parameters != nil:
    body_564202 = parameters
  add(path_564200, "accountName", newJString(accountName))
  result = call_564199.call(path_564200, query_564201, nil, nil, body_564202)

var accountCreateOrUpdateFirewallRule* = Call_AccountCreateOrUpdateFirewallRule_564172(
    name: "accountCreateOrUpdateFirewallRule", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataLakeStore/accounts/{accountName}/firewallRules/{name}",
    validator: validate_AccountCreateOrUpdateFirewallRule_564173, base: "",
    url: url_AccountCreateOrUpdateFirewallRule_564174, schemes: {Scheme.Https})
type
  Call_AccountCreate_564203 = ref object of OpenApiRestCall_563539
proc url_AccountCreate_564205(protocol: Scheme; host: string; base: string;
                             route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.DataLakeStore/accounts/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AccountCreate_564204(path: JsonNode; query: JsonNode; header: JsonNode;
                                  formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates the specified Data Lake Store account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The name of the Data Lake Store account to create.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the Azure resource group that contains the Data Lake Store account.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_564206 = path.getOrDefault("name")
  valid_564206 = validateParameter(valid_564206, JString, required = true,
                                 default = nil)
  if valid_564206 != nil:
    section.add "name", valid_564206
  var valid_564207 = path.getOrDefault("subscriptionId")
  valid_564207 = validateParameter(valid_564207, JString, required = true,
                                 default = nil)
  if valid_564207 != nil:
    section.add "subscriptionId", valid_564207
  var valid_564208 = path.getOrDefault("resourceGroupName")
  valid_564208 = validateParameter(valid_564208, JString, required = true,
                                 default = nil)
  if valid_564208 != nil:
    section.add "resourceGroupName", valid_564208
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564209 = query.getOrDefault("api-version")
  valid_564209 = validateParameter(valid_564209, JString, required = true,
                                 default = nil)
  if valid_564209 != nil:
    section.add "api-version", valid_564209
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters supplied to create the Data Lake Store account.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564211: Call_AccountCreate_564203; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates the specified Data Lake Store account.
  ## 
  let valid = call_564211.validator(path, query, header, formData, body)
  let scheme = call_564211.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564211.url(scheme.get, call_564211.host, call_564211.base,
                         call_564211.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564211, url, valid)

proc call*(call_564212: Call_AccountCreate_564203; apiVersion: string; name: string;
          subscriptionId: string; resourceGroupName: string; parameters: JsonNode): Recallable =
  ## accountCreate
  ## Creates the specified Data Lake Store account.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   name: string (required)
  ##       : The name of the Data Lake Store account to create.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the Azure resource group that contains the Data Lake Store account.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to create the Data Lake Store account.
  var path_564213 = newJObject()
  var query_564214 = newJObject()
  var body_564215 = newJObject()
  add(query_564214, "api-version", newJString(apiVersion))
  add(path_564213, "name", newJString(name))
  add(path_564213, "subscriptionId", newJString(subscriptionId))
  add(path_564213, "resourceGroupName", newJString(resourceGroupName))
  if parameters != nil:
    body_564215 = parameters
  result = call_564212.call(path_564213, query_564214, nil, nil, body_564215)

var accountCreate* = Call_AccountCreate_564203(name: "accountCreate",
    meth: HttpMethod.HttpPut, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataLakeStore/accounts/{name}",
    validator: validate_AccountCreate_564204, base: "", url: url_AccountCreate_564205,
    schemes: {Scheme.Https})
type
  Call_AccountUpdate_564216 = ref object of OpenApiRestCall_563539
proc url_AccountUpdate_564218(protocol: Scheme; host: string; base: string;
                             route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.DataLakeStore/accounts/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AccountUpdate_564217(path: JsonNode; query: JsonNode; header: JsonNode;
                                  formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates the specified Data Lake Store account information.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The name of the Data Lake Store account to update.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the Azure resource group that contains the Data Lake Store account.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_564219 = path.getOrDefault("name")
  valid_564219 = validateParameter(valid_564219, JString, required = true,
                                 default = nil)
  if valid_564219 != nil:
    section.add "name", valid_564219
  var valid_564220 = path.getOrDefault("subscriptionId")
  valid_564220 = validateParameter(valid_564220, JString, required = true,
                                 default = nil)
  if valid_564220 != nil:
    section.add "subscriptionId", valid_564220
  var valid_564221 = path.getOrDefault("resourceGroupName")
  valid_564221 = validateParameter(valid_564221, JString, required = true,
                                 default = nil)
  if valid_564221 != nil:
    section.add "resourceGroupName", valid_564221
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564222 = query.getOrDefault("api-version")
  valid_564222 = validateParameter(valid_564222, JString, required = true,
                                 default = nil)
  if valid_564222 != nil:
    section.add "api-version", valid_564222
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters supplied to update the Data Lake Store account.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564224: Call_AccountUpdate_564216; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the specified Data Lake Store account information.
  ## 
  let valid = call_564224.validator(path, query, header, formData, body)
  let scheme = call_564224.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564224.url(scheme.get, call_564224.host, call_564224.base,
                         call_564224.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564224, url, valid)

proc call*(call_564225: Call_AccountUpdate_564216; apiVersion: string; name: string;
          subscriptionId: string; resourceGroupName: string; parameters: JsonNode): Recallable =
  ## accountUpdate
  ## Updates the specified Data Lake Store account information.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   name: string (required)
  ##       : The name of the Data Lake Store account to update.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the Azure resource group that contains the Data Lake Store account.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to update the Data Lake Store account.
  var path_564226 = newJObject()
  var query_564227 = newJObject()
  var body_564228 = newJObject()
  add(query_564227, "api-version", newJString(apiVersion))
  add(path_564226, "name", newJString(name))
  add(path_564226, "subscriptionId", newJString(subscriptionId))
  add(path_564226, "resourceGroupName", newJString(resourceGroupName))
  if parameters != nil:
    body_564228 = parameters
  result = call_564225.call(path_564226, query_564227, nil, nil, body_564228)

var accountUpdate* = Call_AccountUpdate_564216(name: "accountUpdate",
    meth: HttpMethod.HttpPatch, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataLakeStore/accounts/{name}",
    validator: validate_AccountUpdate_564217, base: "", url: url_AccountUpdate_564218,
    schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)

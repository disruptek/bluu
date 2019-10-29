
import
  json, options, hashes, uri, rest, os, uri, httpcore

## auto-generated via openapi macro
## title: DataLakeAnalyticsAccountManagementClient
## version: 2015-10-01-preview
## termsOfService: (not provided)
## license: (not provided)
## 
## Creates an Azure Data Lake Analytics account management client.
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
  macServiceName = "datalake-analytics-account"
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
        value: "/providers/Microsoft.DataLakeAnalytics/accounts")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AccountList_563762(path: JsonNode; query: JsonNode; header: JsonNode;
                                formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the first page of Data Lake Analytics accounts, if any, within the current subscription. This includes a link to the next page, if any.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Get subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
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
  ## Gets the first page of Data Lake Analytics accounts, if any, within the current subscription. This includes a link to the next page, if any.
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
  ## Gets the first page of Data Lake Analytics accounts, if any, within the current subscription. This includes a link to the next page, if any.
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
  ##                 : Get subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
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
                                        host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.DataLakeAnalytics/accounts",
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
        value: "/providers/Microsoft.DataLakeAnalytics/accounts")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AccountListByResourceGroup_564086(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the first page of Data Lake Analytics accounts, if any, within a specific resource group. This includes a link to the next page, if any.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Get subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the Azure resource group that contains the Data Lake Analytics account.
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
  ##         : The Boolean value of true or false to request a count of the matching resources included with the resources in the response, e.g. Categories?$count=true. Optional.
  ##   $format: JString
  ##          : The return format. Return the response in particular format without access to request headers for standard content-type negotiation (e.g Orders?$format=json). Optional.
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
  ## Gets the first page of Data Lake Analytics accounts, if any, within a specific resource group. This includes a link to the next page, if any.
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
  ## Gets the first page of Data Lake Analytics accounts, if any, within a specific resource group. This includes a link to the next page, if any.
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
  ##         : The return format. Return the response in particular format without access to request headers for standard content-type negotiation (e.g Orders?$format=json). Optional.
  ##   subscriptionId: string (required)
  ##                 : Get subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   Orderby: string
  ##          : OrderBy clause. One or more comma-separated expressions with an optional "asc" (the default) or "desc" depending on the order you'd like the values sorted, e.g. Categories?$orderby=CategoryName desc. Optional.
  ##   Skip: int
  ##       : The number of items to skip over before returning elements. Optional.
  ##   resourceGroupName: string (required)
  ##                    : The name of the Azure resource group that contains the Data Lake Analytics account.
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
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataLakeAnalytics/accounts",
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
        value: "/providers/Microsoft.DataLakeAnalytics/accounts/"),
               (kind: VariableSegment, value: "accountName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AccountGet_564105(path: JsonNode; query: JsonNode; header: JsonNode;
                               formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets details of the specified Data Lake Analytics account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Get subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the Azure resource group that contains the Data Lake Analytics account.
  ##   accountName: JString (required)
  ##              : The name of the Data Lake Analytics account to retrieve.
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
  ## Gets details of the specified Data Lake Analytics account.
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
  ## Gets details of the specified Data Lake Analytics account.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Get subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the Azure resource group that contains the Data Lake Analytics account.
  ##   accountName: string (required)
  ##              : The name of the Data Lake Analytics account to retrieve.
  var path_564113 = newJObject()
  var query_564114 = newJObject()
  add(query_564114, "api-version", newJString(apiVersion))
  add(path_564113, "subscriptionId", newJString(subscriptionId))
  add(path_564113, "resourceGroupName", newJString(resourceGroupName))
  add(path_564113, "accountName", newJString(accountName))
  result = call_564112.call(path_564113, query_564114, nil, nil, nil)

var accountGet* = Call_AccountGet_564104(name: "accountGet",
                                      meth: HttpMethod.HttpGet,
                                      host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataLakeAnalytics/accounts/{accountName}",
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
        value: "/providers/Microsoft.DataLakeAnalytics/accounts/"),
               (kind: VariableSegment, value: "accountName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AccountDelete_564116(path: JsonNode; query: JsonNode; header: JsonNode;
                                  formData: JsonNode; body: JsonNode): JsonNode =
  ## Begins the delete process for the Data Lake Analytics account object specified by the account name.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Get subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the Azure resource group that contains the Data Lake Analytics account.
  ##   accountName: JString (required)
  ##              : The name of the Data Lake Analytics account to delete
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
  ## Begins the delete process for the Data Lake Analytics account object specified by the account name.
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
  ## Begins the delete process for the Data Lake Analytics account object specified by the account name.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Get subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the Azure resource group that contains the Data Lake Analytics account.
  ##   accountName: string (required)
  ##              : The name of the Data Lake Analytics account to delete
  var path_564124 = newJObject()
  var query_564125 = newJObject()
  add(query_564125, "api-version", newJString(apiVersion))
  add(path_564124, "subscriptionId", newJString(subscriptionId))
  add(path_564124, "resourceGroupName", newJString(resourceGroupName))
  add(path_564124, "accountName", newJString(accountName))
  result = call_564123.call(path_564124, query_564125, nil, nil, nil)

var accountDelete* = Call_AccountDelete_564115(name: "accountDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataLakeAnalytics/accounts/{accountName}",
    validator: validate_AccountDelete_564116, base: "", url: url_AccountDelete_564117,
    schemes: {Scheme.Https})
type
  Call_AccountListDataLakeStoreAccounts_564126 = ref object of OpenApiRestCall_563539
proc url_AccountListDataLakeStoreAccounts_564128(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
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
        value: "/providers/Microsoft.DataLakeAnalytics/accounts/"),
               (kind: VariableSegment, value: "accountName"),
               (kind: ConstantSegment, value: "/DataLakeStoreAccounts/")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AccountListDataLakeStoreAccounts_564127(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the first page of Data Lake Store accounts linked to the specified Data Lake Analytics account. The response includes a link to the next page, if any.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Get subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the Azure resource group that contains the Data Lake Analytics account.
  ##   accountName: JString (required)
  ##              : The name of the Data Lake Analytics account for which to list Data Lake Store accounts.
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
  var valid_564132 = query.getOrDefault("$top")
  valid_564132 = validateParameter(valid_564132, JInt, required = false, default = nil)
  if valid_564132 != nil:
    section.add "$top", valid_564132
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564133 = query.getOrDefault("api-version")
  valid_564133 = validateParameter(valid_564133, JString, required = true,
                                 default = nil)
  if valid_564133 != nil:
    section.add "api-version", valid_564133
  var valid_564134 = query.getOrDefault("$select")
  valid_564134 = validateParameter(valid_564134, JString, required = false,
                                 default = nil)
  if valid_564134 != nil:
    section.add "$select", valid_564134
  var valid_564135 = query.getOrDefault("$expand")
  valid_564135 = validateParameter(valid_564135, JString, required = false,
                                 default = nil)
  if valid_564135 != nil:
    section.add "$expand", valid_564135
  var valid_564136 = query.getOrDefault("$count")
  valid_564136 = validateParameter(valid_564136, JBool, required = false, default = nil)
  if valid_564136 != nil:
    section.add "$count", valid_564136
  var valid_564137 = query.getOrDefault("$format")
  valid_564137 = validateParameter(valid_564137, JString, required = false,
                                 default = nil)
  if valid_564137 != nil:
    section.add "$format", valid_564137
  var valid_564138 = query.getOrDefault("$orderby")
  valid_564138 = validateParameter(valid_564138, JString, required = false,
                                 default = nil)
  if valid_564138 != nil:
    section.add "$orderby", valid_564138
  var valid_564139 = query.getOrDefault("$skip")
  valid_564139 = validateParameter(valid_564139, JInt, required = false, default = nil)
  if valid_564139 != nil:
    section.add "$skip", valid_564139
  var valid_564140 = query.getOrDefault("$filter")
  valid_564140 = validateParameter(valid_564140, JString, required = false,
                                 default = nil)
  if valid_564140 != nil:
    section.add "$filter", valid_564140
  var valid_564141 = query.getOrDefault("$search")
  valid_564141 = validateParameter(valid_564141, JString, required = false,
                                 default = nil)
  if valid_564141 != nil:
    section.add "$search", valid_564141
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564142: Call_AccountListDataLakeStoreAccounts_564126;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the first page of Data Lake Store accounts linked to the specified Data Lake Analytics account. The response includes a link to the next page, if any.
  ## 
  let valid = call_564142.validator(path, query, header, formData, body)
  let scheme = call_564142.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564142.url(scheme.get, call_564142.host, call_564142.base,
                         call_564142.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564142, url, valid)

proc call*(call_564143: Call_AccountListDataLakeStoreAccounts_564126;
          apiVersion: string; subscriptionId: string; resourceGroupName: string;
          accountName: string; Top: int = 0; Select: string = ""; Expand: string = "";
          Count: bool = false; Format: string = ""; Orderby: string = ""; Skip: int = 0;
          Filter: string = ""; Search: string = ""): Recallable =
  ## accountListDataLakeStoreAccounts
  ## Gets the first page of Data Lake Store accounts linked to the specified Data Lake Analytics account. The response includes a link to the next page, if any.
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
  ##                 : Get subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   Orderby: string
  ##          : OrderBy clause. One or more comma-separated expressions with an optional "asc" (the default) or "desc" depending on the order you'd like the values sorted, e.g. Categories?$orderby=CategoryName desc. Optional.
  ##   Skip: int
  ##       : The number of items to skip over before returning elements. Optional.
  ##   resourceGroupName: string (required)
  ##                    : The name of the Azure resource group that contains the Data Lake Analytics account.
  ##   Filter: string
  ##         : OData filter. Optional.
  ##   Search: string
  ##         : A free form search. A free-text search expression to match for whether a particular entry should be included in the feed, e.g. Categories?$search=blue OR green. Optional.
  ##   accountName: string (required)
  ##              : The name of the Data Lake Analytics account for which to list Data Lake Store accounts.
  var path_564144 = newJObject()
  var query_564145 = newJObject()
  add(query_564145, "$top", newJInt(Top))
  add(query_564145, "api-version", newJString(apiVersion))
  add(query_564145, "$select", newJString(Select))
  add(query_564145, "$expand", newJString(Expand))
  add(query_564145, "$count", newJBool(Count))
  add(query_564145, "$format", newJString(Format))
  add(path_564144, "subscriptionId", newJString(subscriptionId))
  add(query_564145, "$orderby", newJString(Orderby))
  add(query_564145, "$skip", newJInt(Skip))
  add(path_564144, "resourceGroupName", newJString(resourceGroupName))
  add(query_564145, "$filter", newJString(Filter))
  add(query_564145, "$search", newJString(Search))
  add(path_564144, "accountName", newJString(accountName))
  result = call_564143.call(path_564144, query_564145, nil, nil, nil)

var accountListDataLakeStoreAccounts* = Call_AccountListDataLakeStoreAccounts_564126(
    name: "accountListDataLakeStoreAccounts", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataLakeAnalytics/accounts/{accountName}/DataLakeStoreAccounts/",
    validator: validate_AccountListDataLakeStoreAccounts_564127, base: "",
    url: url_AccountListDataLakeStoreAccounts_564128, schemes: {Scheme.Https})
type
  Call_AccountAddDataLakeStoreAccount_564158 = ref object of OpenApiRestCall_563539
proc url_AccountAddDataLakeStoreAccount_564160(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "accountName" in path, "`accountName` is a required path parameter"
  assert "dataLakeStoreAccountName" in path,
        "`dataLakeStoreAccountName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.DataLakeAnalytics/accounts/"),
               (kind: VariableSegment, value: "accountName"),
               (kind: ConstantSegment, value: "/DataLakeStoreAccounts/"),
               (kind: VariableSegment, value: "dataLakeStoreAccountName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AccountAddDataLakeStoreAccount_564159(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates the specified Data Lake Analytics account to include the additional Data Lake Store account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Get subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   dataLakeStoreAccountName: JString (required)
  ##                           : The name of the Data Lake Store account to add.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the Azure resource group that contains the Data Lake Analytics account.
  ##   accountName: JString (required)
  ##              : The name of the Data Lake Analytics account to which to add the Data Lake Store account.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564178 = path.getOrDefault("subscriptionId")
  valid_564178 = validateParameter(valid_564178, JString, required = true,
                                 default = nil)
  if valid_564178 != nil:
    section.add "subscriptionId", valid_564178
  var valid_564179 = path.getOrDefault("dataLakeStoreAccountName")
  valid_564179 = validateParameter(valid_564179, JString, required = true,
                                 default = nil)
  if valid_564179 != nil:
    section.add "dataLakeStoreAccountName", valid_564179
  var valid_564180 = path.getOrDefault("resourceGroupName")
  valid_564180 = validateParameter(valid_564180, JString, required = true,
                                 default = nil)
  if valid_564180 != nil:
    section.add "resourceGroupName", valid_564180
  var valid_564181 = path.getOrDefault("accountName")
  valid_564181 = validateParameter(valid_564181, JString, required = true,
                                 default = nil)
  if valid_564181 != nil:
    section.add "accountName", valid_564181
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564182 = query.getOrDefault("api-version")
  valid_564182 = validateParameter(valid_564182, JString, required = true,
                                 default = nil)
  if valid_564182 != nil:
    section.add "api-version", valid_564182
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : The details of the Data Lake Store account.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564184: Call_AccountAddDataLakeStoreAccount_564158; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the specified Data Lake Analytics account to include the additional Data Lake Store account.
  ## 
  let valid = call_564184.validator(path, query, header, formData, body)
  let scheme = call_564184.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564184.url(scheme.get, call_564184.host, call_564184.base,
                         call_564184.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564184, url, valid)

proc call*(call_564185: Call_AccountAddDataLakeStoreAccount_564158;
          apiVersion: string; subscriptionId: string;
          dataLakeStoreAccountName: string; resourceGroupName: string;
          parameters: JsonNode; accountName: string): Recallable =
  ## accountAddDataLakeStoreAccount
  ## Updates the specified Data Lake Analytics account to include the additional Data Lake Store account.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Get subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   dataLakeStoreAccountName: string (required)
  ##                           : The name of the Data Lake Store account to add.
  ##   resourceGroupName: string (required)
  ##                    : The name of the Azure resource group that contains the Data Lake Analytics account.
  ##   parameters: JObject (required)
  ##             : The details of the Data Lake Store account.
  ##   accountName: string (required)
  ##              : The name of the Data Lake Analytics account to which to add the Data Lake Store account.
  var path_564186 = newJObject()
  var query_564187 = newJObject()
  var body_564188 = newJObject()
  add(query_564187, "api-version", newJString(apiVersion))
  add(path_564186, "subscriptionId", newJString(subscriptionId))
  add(path_564186, "dataLakeStoreAccountName",
      newJString(dataLakeStoreAccountName))
  add(path_564186, "resourceGroupName", newJString(resourceGroupName))
  if parameters != nil:
    body_564188 = parameters
  add(path_564186, "accountName", newJString(accountName))
  result = call_564185.call(path_564186, query_564187, nil, nil, body_564188)

var accountAddDataLakeStoreAccount* = Call_AccountAddDataLakeStoreAccount_564158(
    name: "accountAddDataLakeStoreAccount", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataLakeAnalytics/accounts/{accountName}/DataLakeStoreAccounts/{dataLakeStoreAccountName}",
    validator: validate_AccountAddDataLakeStoreAccount_564159, base: "",
    url: url_AccountAddDataLakeStoreAccount_564160, schemes: {Scheme.Https})
type
  Call_AccountGetDataLakeStoreAccount_564146 = ref object of OpenApiRestCall_563539
proc url_AccountGetDataLakeStoreAccount_564148(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "accountName" in path, "`accountName` is a required path parameter"
  assert "dataLakeStoreAccountName" in path,
        "`dataLakeStoreAccountName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.DataLakeAnalytics/accounts/"),
               (kind: VariableSegment, value: "accountName"),
               (kind: ConstantSegment, value: "/DataLakeStoreAccounts/"),
               (kind: VariableSegment, value: "dataLakeStoreAccountName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AccountGetDataLakeStoreAccount_564147(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the specified Data Lake Store account details in the specified Data Lake Analytics account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Get subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   dataLakeStoreAccountName: JString (required)
  ##                           : The name of the Data Lake Store account to retrieve
  ##   resourceGroupName: JString (required)
  ##                    : The name of the Azure resource group that contains the Data Lake Analytics account.
  ##   accountName: JString (required)
  ##              : The name of the Data Lake Analytics account from which to retrieve the Data Lake Store account details.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564149 = path.getOrDefault("subscriptionId")
  valid_564149 = validateParameter(valid_564149, JString, required = true,
                                 default = nil)
  if valid_564149 != nil:
    section.add "subscriptionId", valid_564149
  var valid_564150 = path.getOrDefault("dataLakeStoreAccountName")
  valid_564150 = validateParameter(valid_564150, JString, required = true,
                                 default = nil)
  if valid_564150 != nil:
    section.add "dataLakeStoreAccountName", valid_564150
  var valid_564151 = path.getOrDefault("resourceGroupName")
  valid_564151 = validateParameter(valid_564151, JString, required = true,
                                 default = nil)
  if valid_564151 != nil:
    section.add "resourceGroupName", valid_564151
  var valid_564152 = path.getOrDefault("accountName")
  valid_564152 = validateParameter(valid_564152, JString, required = true,
                                 default = nil)
  if valid_564152 != nil:
    section.add "accountName", valid_564152
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564153 = query.getOrDefault("api-version")
  valid_564153 = validateParameter(valid_564153, JString, required = true,
                                 default = nil)
  if valid_564153 != nil:
    section.add "api-version", valid_564153
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564154: Call_AccountGetDataLakeStoreAccount_564146; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the specified Data Lake Store account details in the specified Data Lake Analytics account.
  ## 
  let valid = call_564154.validator(path, query, header, formData, body)
  let scheme = call_564154.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564154.url(scheme.get, call_564154.host, call_564154.base,
                         call_564154.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564154, url, valid)

proc call*(call_564155: Call_AccountGetDataLakeStoreAccount_564146;
          apiVersion: string; subscriptionId: string;
          dataLakeStoreAccountName: string; resourceGroupName: string;
          accountName: string): Recallable =
  ## accountGetDataLakeStoreAccount
  ## Gets the specified Data Lake Store account details in the specified Data Lake Analytics account.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Get subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   dataLakeStoreAccountName: string (required)
  ##                           : The name of the Data Lake Store account to retrieve
  ##   resourceGroupName: string (required)
  ##                    : The name of the Azure resource group that contains the Data Lake Analytics account.
  ##   accountName: string (required)
  ##              : The name of the Data Lake Analytics account from which to retrieve the Data Lake Store account details.
  var path_564156 = newJObject()
  var query_564157 = newJObject()
  add(query_564157, "api-version", newJString(apiVersion))
  add(path_564156, "subscriptionId", newJString(subscriptionId))
  add(path_564156, "dataLakeStoreAccountName",
      newJString(dataLakeStoreAccountName))
  add(path_564156, "resourceGroupName", newJString(resourceGroupName))
  add(path_564156, "accountName", newJString(accountName))
  result = call_564155.call(path_564156, query_564157, nil, nil, nil)

var accountGetDataLakeStoreAccount* = Call_AccountGetDataLakeStoreAccount_564146(
    name: "accountGetDataLakeStoreAccount", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataLakeAnalytics/accounts/{accountName}/DataLakeStoreAccounts/{dataLakeStoreAccountName}",
    validator: validate_AccountGetDataLakeStoreAccount_564147, base: "",
    url: url_AccountGetDataLakeStoreAccount_564148, schemes: {Scheme.Https})
type
  Call_AccountDeleteDataLakeStoreAccount_564189 = ref object of OpenApiRestCall_563539
proc url_AccountDeleteDataLakeStoreAccount_564191(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "accountName" in path, "`accountName` is a required path parameter"
  assert "dataLakeStoreAccountName" in path,
        "`dataLakeStoreAccountName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.DataLakeAnalytics/accounts/"),
               (kind: VariableSegment, value: "accountName"),
               (kind: ConstantSegment, value: "/DataLakeStoreAccounts/"),
               (kind: VariableSegment, value: "dataLakeStoreAccountName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AccountDeleteDataLakeStoreAccount_564190(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates the Data Lake Analytics account specified to remove the specified Data Lake Store account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Get subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   dataLakeStoreAccountName: JString (required)
  ##                           : The name of the Data Lake Store account to remove
  ##   resourceGroupName: JString (required)
  ##                    : The name of the Azure resource group that contains the Data Lake Analytics account.
  ##   accountName: JString (required)
  ##              : The name of the Data Lake Analytics account from which to remove the Data Lake Store account.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564192 = path.getOrDefault("subscriptionId")
  valid_564192 = validateParameter(valid_564192, JString, required = true,
                                 default = nil)
  if valid_564192 != nil:
    section.add "subscriptionId", valid_564192
  var valid_564193 = path.getOrDefault("dataLakeStoreAccountName")
  valid_564193 = validateParameter(valid_564193, JString, required = true,
                                 default = nil)
  if valid_564193 != nil:
    section.add "dataLakeStoreAccountName", valid_564193
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
  if body != nil:
    result.add "body", body

proc call*(call_564197: Call_AccountDeleteDataLakeStoreAccount_564189;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates the Data Lake Analytics account specified to remove the specified Data Lake Store account.
  ## 
  let valid = call_564197.validator(path, query, header, formData, body)
  let scheme = call_564197.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564197.url(scheme.get, call_564197.host, call_564197.base,
                         call_564197.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564197, url, valid)

proc call*(call_564198: Call_AccountDeleteDataLakeStoreAccount_564189;
          apiVersion: string; subscriptionId: string;
          dataLakeStoreAccountName: string; resourceGroupName: string;
          accountName: string): Recallable =
  ## accountDeleteDataLakeStoreAccount
  ## Updates the Data Lake Analytics account specified to remove the specified Data Lake Store account.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Get subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   dataLakeStoreAccountName: string (required)
  ##                           : The name of the Data Lake Store account to remove
  ##   resourceGroupName: string (required)
  ##                    : The name of the Azure resource group that contains the Data Lake Analytics account.
  ##   accountName: string (required)
  ##              : The name of the Data Lake Analytics account from which to remove the Data Lake Store account.
  var path_564199 = newJObject()
  var query_564200 = newJObject()
  add(query_564200, "api-version", newJString(apiVersion))
  add(path_564199, "subscriptionId", newJString(subscriptionId))
  add(path_564199, "dataLakeStoreAccountName",
      newJString(dataLakeStoreAccountName))
  add(path_564199, "resourceGroupName", newJString(resourceGroupName))
  add(path_564199, "accountName", newJString(accountName))
  result = call_564198.call(path_564199, query_564200, nil, nil, nil)

var accountDeleteDataLakeStoreAccount* = Call_AccountDeleteDataLakeStoreAccount_564189(
    name: "accountDeleteDataLakeStoreAccount", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataLakeAnalytics/accounts/{accountName}/DataLakeStoreAccounts/{dataLakeStoreAccountName}",
    validator: validate_AccountDeleteDataLakeStoreAccount_564190, base: "",
    url: url_AccountDeleteDataLakeStoreAccount_564191, schemes: {Scheme.Https})
type
  Call_AccountListStorageAccounts_564201 = ref object of OpenApiRestCall_563539
proc url_AccountListStorageAccounts_564203(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
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
        value: "/providers/Microsoft.DataLakeAnalytics/accounts/"),
               (kind: VariableSegment, value: "accountName"),
               (kind: ConstantSegment, value: "/StorageAccounts/")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AccountListStorageAccounts_564202(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the first page of Azure Storage accounts, if any, linked to the specified Data Lake Analytics account. The response includes a link to the next page, if any.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Get subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the Azure resource group that contains the Data Lake Analytics account.
  ##   accountName: JString (required)
  ##              : The name of the Data Lake Analytics account for which to list Azure Storage accounts.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564204 = path.getOrDefault("subscriptionId")
  valid_564204 = validateParameter(valid_564204, JString, required = true,
                                 default = nil)
  if valid_564204 != nil:
    section.add "subscriptionId", valid_564204
  var valid_564205 = path.getOrDefault("resourceGroupName")
  valid_564205 = validateParameter(valid_564205, JString, required = true,
                                 default = nil)
  if valid_564205 != nil:
    section.add "resourceGroupName", valid_564205
  var valid_564206 = path.getOrDefault("accountName")
  valid_564206 = validateParameter(valid_564206, JString, required = true,
                                 default = nil)
  if valid_564206 != nil:
    section.add "accountName", valid_564206
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
  ##          : The OData filter. Optional.
  ##   $search: JString
  ##          : A free form search. A free-text search expression to match for whether a particular entry should be included in the feed, e.g. Categories?$search=blue OR green. Optional.
  section = newJObject()
  var valid_564207 = query.getOrDefault("$top")
  valid_564207 = validateParameter(valid_564207, JInt, required = false, default = nil)
  if valid_564207 != nil:
    section.add "$top", valid_564207
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564208 = query.getOrDefault("api-version")
  valid_564208 = validateParameter(valid_564208, JString, required = true,
                                 default = nil)
  if valid_564208 != nil:
    section.add "api-version", valid_564208
  var valid_564209 = query.getOrDefault("$select")
  valid_564209 = validateParameter(valid_564209, JString, required = false,
                                 default = nil)
  if valid_564209 != nil:
    section.add "$select", valid_564209
  var valid_564210 = query.getOrDefault("$expand")
  valid_564210 = validateParameter(valid_564210, JString, required = false,
                                 default = nil)
  if valid_564210 != nil:
    section.add "$expand", valid_564210
  var valid_564211 = query.getOrDefault("$count")
  valid_564211 = validateParameter(valid_564211, JBool, required = false, default = nil)
  if valid_564211 != nil:
    section.add "$count", valid_564211
  var valid_564212 = query.getOrDefault("$format")
  valid_564212 = validateParameter(valid_564212, JString, required = false,
                                 default = nil)
  if valid_564212 != nil:
    section.add "$format", valid_564212
  var valid_564213 = query.getOrDefault("$orderby")
  valid_564213 = validateParameter(valid_564213, JString, required = false,
                                 default = nil)
  if valid_564213 != nil:
    section.add "$orderby", valid_564213
  var valid_564214 = query.getOrDefault("$skip")
  valid_564214 = validateParameter(valid_564214, JInt, required = false, default = nil)
  if valid_564214 != nil:
    section.add "$skip", valid_564214
  var valid_564215 = query.getOrDefault("$filter")
  valid_564215 = validateParameter(valid_564215, JString, required = false,
                                 default = nil)
  if valid_564215 != nil:
    section.add "$filter", valid_564215
  var valid_564216 = query.getOrDefault("$search")
  valid_564216 = validateParameter(valid_564216, JString, required = false,
                                 default = nil)
  if valid_564216 != nil:
    section.add "$search", valid_564216
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564217: Call_AccountListStorageAccounts_564201; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the first page of Azure Storage accounts, if any, linked to the specified Data Lake Analytics account. The response includes a link to the next page, if any.
  ## 
  let valid = call_564217.validator(path, query, header, formData, body)
  let scheme = call_564217.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564217.url(scheme.get, call_564217.host, call_564217.base,
                         call_564217.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564217, url, valid)

proc call*(call_564218: Call_AccountListStorageAccounts_564201; apiVersion: string;
          subscriptionId: string; resourceGroupName: string; accountName: string;
          Top: int = 0; Select: string = ""; Expand: string = ""; Count: bool = false;
          Format: string = ""; Orderby: string = ""; Skip: int = 0; Filter: string = "";
          Search: string = ""): Recallable =
  ## accountListStorageAccounts
  ## Gets the first page of Azure Storage accounts, if any, linked to the specified Data Lake Analytics account. The response includes a link to the next page, if any.
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
  ##                 : Get subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   Orderby: string
  ##          : OrderBy clause. One or more comma-separated expressions with an optional "asc" (the default) or "desc" depending on the order you'd like the values sorted, e.g. Categories?$orderby=CategoryName desc. Optional.
  ##   Skip: int
  ##       : The number of items to skip over before returning elements. Optional.
  ##   resourceGroupName: string (required)
  ##                    : The name of the Azure resource group that contains the Data Lake Analytics account.
  ##   Filter: string
  ##         : The OData filter. Optional.
  ##   Search: string
  ##         : A free form search. A free-text search expression to match for whether a particular entry should be included in the feed, e.g. Categories?$search=blue OR green. Optional.
  ##   accountName: string (required)
  ##              : The name of the Data Lake Analytics account for which to list Azure Storage accounts.
  var path_564219 = newJObject()
  var query_564220 = newJObject()
  add(query_564220, "$top", newJInt(Top))
  add(query_564220, "api-version", newJString(apiVersion))
  add(query_564220, "$select", newJString(Select))
  add(query_564220, "$expand", newJString(Expand))
  add(query_564220, "$count", newJBool(Count))
  add(query_564220, "$format", newJString(Format))
  add(path_564219, "subscriptionId", newJString(subscriptionId))
  add(query_564220, "$orderby", newJString(Orderby))
  add(query_564220, "$skip", newJInt(Skip))
  add(path_564219, "resourceGroupName", newJString(resourceGroupName))
  add(query_564220, "$filter", newJString(Filter))
  add(query_564220, "$search", newJString(Search))
  add(path_564219, "accountName", newJString(accountName))
  result = call_564218.call(path_564219, query_564220, nil, nil, nil)

var accountListStorageAccounts* = Call_AccountListStorageAccounts_564201(
    name: "accountListStorageAccounts", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataLakeAnalytics/accounts/{accountName}/StorageAccounts/",
    validator: validate_AccountListStorageAccounts_564202, base: "",
    url: url_AccountListStorageAccounts_564203, schemes: {Scheme.Https})
type
  Call_AccountAddStorageAccount_564233 = ref object of OpenApiRestCall_563539
proc url_AccountAddStorageAccount_564235(protocol: Scheme; host: string;
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
  assert "storageAccountName" in path,
        "`storageAccountName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.DataLakeAnalytics/accounts/"),
               (kind: VariableSegment, value: "accountName"),
               (kind: ConstantSegment, value: "/StorageAccounts/"),
               (kind: VariableSegment, value: "storageAccountName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AccountAddStorageAccount_564234(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates the specified Data Lake Analytics account to add an Azure Storage account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Get subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the Azure resource group that contains the Data Lake Analytics account.
  ##   storageAccountName: JString (required)
  ##                     : The name of the Azure Storage account to add
  ##   accountName: JString (required)
  ##              : The name of the Data Lake Analytics account to which to add the Azure Storage account.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564236 = path.getOrDefault("subscriptionId")
  valid_564236 = validateParameter(valid_564236, JString, required = true,
                                 default = nil)
  if valid_564236 != nil:
    section.add "subscriptionId", valid_564236
  var valid_564237 = path.getOrDefault("resourceGroupName")
  valid_564237 = validateParameter(valid_564237, JString, required = true,
                                 default = nil)
  if valid_564237 != nil:
    section.add "resourceGroupName", valid_564237
  var valid_564238 = path.getOrDefault("storageAccountName")
  valid_564238 = validateParameter(valid_564238, JString, required = true,
                                 default = nil)
  if valid_564238 != nil:
    section.add "storageAccountName", valid_564238
  var valid_564239 = path.getOrDefault("accountName")
  valid_564239 = validateParameter(valid_564239, JString, required = true,
                                 default = nil)
  if valid_564239 != nil:
    section.add "accountName", valid_564239
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564240 = query.getOrDefault("api-version")
  valid_564240 = validateParameter(valid_564240, JString, required = true,
                                 default = nil)
  if valid_564240 != nil:
    section.add "api-version", valid_564240
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : The parameters containing the access key and optional suffix for the Azure Storage Account.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564242: Call_AccountAddStorageAccount_564233; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the specified Data Lake Analytics account to add an Azure Storage account.
  ## 
  let valid = call_564242.validator(path, query, header, formData, body)
  let scheme = call_564242.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564242.url(scheme.get, call_564242.host, call_564242.base,
                         call_564242.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564242, url, valid)

proc call*(call_564243: Call_AccountAddStorageAccount_564233; apiVersion: string;
          subscriptionId: string; resourceGroupName: string;
          storageAccountName: string; parameters: JsonNode; accountName: string): Recallable =
  ## accountAddStorageAccount
  ## Updates the specified Data Lake Analytics account to add an Azure Storage account.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Get subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the Azure resource group that contains the Data Lake Analytics account.
  ##   storageAccountName: string (required)
  ##                     : The name of the Azure Storage account to add
  ##   parameters: JObject (required)
  ##             : The parameters containing the access key and optional suffix for the Azure Storage Account.
  ##   accountName: string (required)
  ##              : The name of the Data Lake Analytics account to which to add the Azure Storage account.
  var path_564244 = newJObject()
  var query_564245 = newJObject()
  var body_564246 = newJObject()
  add(query_564245, "api-version", newJString(apiVersion))
  add(path_564244, "subscriptionId", newJString(subscriptionId))
  add(path_564244, "resourceGroupName", newJString(resourceGroupName))
  add(path_564244, "storageAccountName", newJString(storageAccountName))
  if parameters != nil:
    body_564246 = parameters
  add(path_564244, "accountName", newJString(accountName))
  result = call_564243.call(path_564244, query_564245, nil, nil, body_564246)

var accountAddStorageAccount* = Call_AccountAddStorageAccount_564233(
    name: "accountAddStorageAccount", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataLakeAnalytics/accounts/{accountName}/StorageAccounts/{storageAccountName}",
    validator: validate_AccountAddStorageAccount_564234, base: "",
    url: url_AccountAddStorageAccount_564235, schemes: {Scheme.Https})
type
  Call_AccountGetStorageAccount_564221 = ref object of OpenApiRestCall_563539
proc url_AccountGetStorageAccount_564223(protocol: Scheme; host: string;
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
  assert "storageAccountName" in path,
        "`storageAccountName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.DataLakeAnalytics/accounts/"),
               (kind: VariableSegment, value: "accountName"),
               (kind: ConstantSegment, value: "/StorageAccounts/"),
               (kind: VariableSegment, value: "storageAccountName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AccountGetStorageAccount_564222(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the specified Azure Storage account linked to the given Data Lake Analytics account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Get subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the Azure resource group that contains the Data Lake Analytics account.
  ##   storageAccountName: JString (required)
  ##                     : The name of the Azure Storage account for which to retrieve the details.
  ##   accountName: JString (required)
  ##              : The name of the Data Lake Analytics account from which to retrieve Azure storage account details.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564224 = path.getOrDefault("subscriptionId")
  valid_564224 = validateParameter(valid_564224, JString, required = true,
                                 default = nil)
  if valid_564224 != nil:
    section.add "subscriptionId", valid_564224
  var valid_564225 = path.getOrDefault("resourceGroupName")
  valid_564225 = validateParameter(valid_564225, JString, required = true,
                                 default = nil)
  if valid_564225 != nil:
    section.add "resourceGroupName", valid_564225
  var valid_564226 = path.getOrDefault("storageAccountName")
  valid_564226 = validateParameter(valid_564226, JString, required = true,
                                 default = nil)
  if valid_564226 != nil:
    section.add "storageAccountName", valid_564226
  var valid_564227 = path.getOrDefault("accountName")
  valid_564227 = validateParameter(valid_564227, JString, required = true,
                                 default = nil)
  if valid_564227 != nil:
    section.add "accountName", valid_564227
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564228 = query.getOrDefault("api-version")
  valid_564228 = validateParameter(valid_564228, JString, required = true,
                                 default = nil)
  if valid_564228 != nil:
    section.add "api-version", valid_564228
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564229: Call_AccountGetStorageAccount_564221; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the specified Azure Storage account linked to the given Data Lake Analytics account.
  ## 
  let valid = call_564229.validator(path, query, header, formData, body)
  let scheme = call_564229.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564229.url(scheme.get, call_564229.host, call_564229.base,
                         call_564229.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564229, url, valid)

proc call*(call_564230: Call_AccountGetStorageAccount_564221; apiVersion: string;
          subscriptionId: string; resourceGroupName: string;
          storageAccountName: string; accountName: string): Recallable =
  ## accountGetStorageAccount
  ## Gets the specified Azure Storage account linked to the given Data Lake Analytics account.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Get subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the Azure resource group that contains the Data Lake Analytics account.
  ##   storageAccountName: string (required)
  ##                     : The name of the Azure Storage account for which to retrieve the details.
  ##   accountName: string (required)
  ##              : The name of the Data Lake Analytics account from which to retrieve Azure storage account details.
  var path_564231 = newJObject()
  var query_564232 = newJObject()
  add(query_564232, "api-version", newJString(apiVersion))
  add(path_564231, "subscriptionId", newJString(subscriptionId))
  add(path_564231, "resourceGroupName", newJString(resourceGroupName))
  add(path_564231, "storageAccountName", newJString(storageAccountName))
  add(path_564231, "accountName", newJString(accountName))
  result = call_564230.call(path_564231, query_564232, nil, nil, nil)

var accountGetStorageAccount* = Call_AccountGetStorageAccount_564221(
    name: "accountGetStorageAccount", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataLakeAnalytics/accounts/{accountName}/StorageAccounts/{storageAccountName}",
    validator: validate_AccountGetStorageAccount_564222, base: "",
    url: url_AccountGetStorageAccount_564223, schemes: {Scheme.Https})
type
  Call_AccountUpdateStorageAccount_564259 = ref object of OpenApiRestCall_563539
proc url_AccountUpdateStorageAccount_564261(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "accountName" in path, "`accountName` is a required path parameter"
  assert "storageAccountName" in path,
        "`storageAccountName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.DataLakeAnalytics/accounts/"),
               (kind: VariableSegment, value: "accountName"),
               (kind: ConstantSegment, value: "/StorageAccounts/"),
               (kind: VariableSegment, value: "storageAccountName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AccountUpdateStorageAccount_564260(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates the Data Lake Analytics account to replace Azure Storage blob account details, such as the access key and/or suffix.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Get subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the Azure resource group that contains the Data Lake Analytics account.
  ##   storageAccountName: JString (required)
  ##                     : The Azure Storage account to modify
  ##   accountName: JString (required)
  ##              : The name of the Data Lake Analytics account to modify storage accounts in
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564262 = path.getOrDefault("subscriptionId")
  valid_564262 = validateParameter(valid_564262, JString, required = true,
                                 default = nil)
  if valid_564262 != nil:
    section.add "subscriptionId", valid_564262
  var valid_564263 = path.getOrDefault("resourceGroupName")
  valid_564263 = validateParameter(valid_564263, JString, required = true,
                                 default = nil)
  if valid_564263 != nil:
    section.add "resourceGroupName", valid_564263
  var valid_564264 = path.getOrDefault("storageAccountName")
  valid_564264 = validateParameter(valid_564264, JString, required = true,
                                 default = nil)
  if valid_564264 != nil:
    section.add "storageAccountName", valid_564264
  var valid_564265 = path.getOrDefault("accountName")
  valid_564265 = validateParameter(valid_564265, JString, required = true,
                                 default = nil)
  if valid_564265 != nil:
    section.add "accountName", valid_564265
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564266 = query.getOrDefault("api-version")
  valid_564266 = validateParameter(valid_564266, JString, required = true,
                                 default = nil)
  if valid_564266 != nil:
    section.add "api-version", valid_564266
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : The parameters containing the access key and suffix to update the storage account with.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564268: Call_AccountUpdateStorageAccount_564259; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the Data Lake Analytics account to replace Azure Storage blob account details, such as the access key and/or suffix.
  ## 
  let valid = call_564268.validator(path, query, header, formData, body)
  let scheme = call_564268.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564268.url(scheme.get, call_564268.host, call_564268.base,
                         call_564268.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564268, url, valid)

proc call*(call_564269: Call_AccountUpdateStorageAccount_564259;
          apiVersion: string; subscriptionId: string; resourceGroupName: string;
          storageAccountName: string; parameters: JsonNode; accountName: string): Recallable =
  ## accountUpdateStorageAccount
  ## Updates the Data Lake Analytics account to replace Azure Storage blob account details, such as the access key and/or suffix.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Get subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the Azure resource group that contains the Data Lake Analytics account.
  ##   storageAccountName: string (required)
  ##                     : The Azure Storage account to modify
  ##   parameters: JObject (required)
  ##             : The parameters containing the access key and suffix to update the storage account with.
  ##   accountName: string (required)
  ##              : The name of the Data Lake Analytics account to modify storage accounts in
  var path_564270 = newJObject()
  var query_564271 = newJObject()
  var body_564272 = newJObject()
  add(query_564271, "api-version", newJString(apiVersion))
  add(path_564270, "subscriptionId", newJString(subscriptionId))
  add(path_564270, "resourceGroupName", newJString(resourceGroupName))
  add(path_564270, "storageAccountName", newJString(storageAccountName))
  if parameters != nil:
    body_564272 = parameters
  add(path_564270, "accountName", newJString(accountName))
  result = call_564269.call(path_564270, query_564271, nil, nil, body_564272)

var accountUpdateStorageAccount* = Call_AccountUpdateStorageAccount_564259(
    name: "accountUpdateStorageAccount", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataLakeAnalytics/accounts/{accountName}/StorageAccounts/{storageAccountName}",
    validator: validate_AccountUpdateStorageAccount_564260, base: "",
    url: url_AccountUpdateStorageAccount_564261, schemes: {Scheme.Https})
type
  Call_AccountDeleteStorageAccount_564247 = ref object of OpenApiRestCall_563539
proc url_AccountDeleteStorageAccount_564249(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "accountName" in path, "`accountName` is a required path parameter"
  assert "storageAccountName" in path,
        "`storageAccountName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.DataLakeAnalytics/accounts/"),
               (kind: VariableSegment, value: "accountName"),
               (kind: ConstantSegment, value: "/StorageAccounts/"),
               (kind: VariableSegment, value: "storageAccountName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AccountDeleteStorageAccount_564248(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates the specified Data Lake Analytics account to remove an Azure Storage account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Get subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the Azure resource group that contains the Data Lake Analytics account.
  ##   storageAccountName: JString (required)
  ##                     : The name of the Azure Storage account to remove
  ##   accountName: JString (required)
  ##              : The name of the Data Lake Analytics account from which to remove the Azure Storage account.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564250 = path.getOrDefault("subscriptionId")
  valid_564250 = validateParameter(valid_564250, JString, required = true,
                                 default = nil)
  if valid_564250 != nil:
    section.add "subscriptionId", valid_564250
  var valid_564251 = path.getOrDefault("resourceGroupName")
  valid_564251 = validateParameter(valid_564251, JString, required = true,
                                 default = nil)
  if valid_564251 != nil:
    section.add "resourceGroupName", valid_564251
  var valid_564252 = path.getOrDefault("storageAccountName")
  valid_564252 = validateParameter(valid_564252, JString, required = true,
                                 default = nil)
  if valid_564252 != nil:
    section.add "storageAccountName", valid_564252
  var valid_564253 = path.getOrDefault("accountName")
  valid_564253 = validateParameter(valid_564253, JString, required = true,
                                 default = nil)
  if valid_564253 != nil:
    section.add "accountName", valid_564253
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564254 = query.getOrDefault("api-version")
  valid_564254 = validateParameter(valid_564254, JString, required = true,
                                 default = nil)
  if valid_564254 != nil:
    section.add "api-version", valid_564254
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564255: Call_AccountDeleteStorageAccount_564247; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the specified Data Lake Analytics account to remove an Azure Storage account.
  ## 
  let valid = call_564255.validator(path, query, header, formData, body)
  let scheme = call_564255.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564255.url(scheme.get, call_564255.host, call_564255.base,
                         call_564255.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564255, url, valid)

proc call*(call_564256: Call_AccountDeleteStorageAccount_564247;
          apiVersion: string; subscriptionId: string; resourceGroupName: string;
          storageAccountName: string; accountName: string): Recallable =
  ## accountDeleteStorageAccount
  ## Updates the specified Data Lake Analytics account to remove an Azure Storage account.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Get subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the Azure resource group that contains the Data Lake Analytics account.
  ##   storageAccountName: string (required)
  ##                     : The name of the Azure Storage account to remove
  ##   accountName: string (required)
  ##              : The name of the Data Lake Analytics account from which to remove the Azure Storage account.
  var path_564257 = newJObject()
  var query_564258 = newJObject()
  add(query_564258, "api-version", newJString(apiVersion))
  add(path_564257, "subscriptionId", newJString(subscriptionId))
  add(path_564257, "resourceGroupName", newJString(resourceGroupName))
  add(path_564257, "storageAccountName", newJString(storageAccountName))
  add(path_564257, "accountName", newJString(accountName))
  result = call_564256.call(path_564257, query_564258, nil, nil, nil)

var accountDeleteStorageAccount* = Call_AccountDeleteStorageAccount_564247(
    name: "accountDeleteStorageAccount", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataLakeAnalytics/accounts/{accountName}/StorageAccounts/{storageAccountName}",
    validator: validate_AccountDeleteStorageAccount_564248, base: "",
    url: url_AccountDeleteStorageAccount_564249, schemes: {Scheme.Https})
type
  Call_AccountListStorageContainers_564273 = ref object of OpenApiRestCall_563539
proc url_AccountListStorageContainers_564275(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "accountName" in path, "`accountName` is a required path parameter"
  assert "storageAccountName" in path,
        "`storageAccountName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.DataLakeAnalytics/accounts/"),
               (kind: VariableSegment, value: "accountName"),
               (kind: ConstantSegment, value: "/StorageAccounts/"),
               (kind: VariableSegment, value: "storageAccountName"),
               (kind: ConstantSegment, value: "/Containers")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AccountListStorageContainers_564274(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists the Azure Storage containers, if any, associated with the specified Data Lake Analytics and Azure Storage account combination. The response includes a link to the next page of results, if any.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Get subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the Azure resource group that contains the Data Lake Analytics account.
  ##   storageAccountName: JString (required)
  ##                     : The name of the Azure storage account from which to list blob containers.
  ##   accountName: JString (required)
  ##              : The name of the Data Lake Analytics account for which to list Azure Storage blob containers.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564276 = path.getOrDefault("subscriptionId")
  valid_564276 = validateParameter(valid_564276, JString, required = true,
                                 default = nil)
  if valid_564276 != nil:
    section.add "subscriptionId", valid_564276
  var valid_564277 = path.getOrDefault("resourceGroupName")
  valid_564277 = validateParameter(valid_564277, JString, required = true,
                                 default = nil)
  if valid_564277 != nil:
    section.add "resourceGroupName", valid_564277
  var valid_564278 = path.getOrDefault("storageAccountName")
  valid_564278 = validateParameter(valid_564278, JString, required = true,
                                 default = nil)
  if valid_564278 != nil:
    section.add "storageAccountName", valid_564278
  var valid_564279 = path.getOrDefault("accountName")
  valid_564279 = validateParameter(valid_564279, JString, required = true,
                                 default = nil)
  if valid_564279 != nil:
    section.add "accountName", valid_564279
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564280 = query.getOrDefault("api-version")
  valid_564280 = validateParameter(valid_564280, JString, required = true,
                                 default = nil)
  if valid_564280 != nil:
    section.add "api-version", valid_564280
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564281: Call_AccountListStorageContainers_564273; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the Azure Storage containers, if any, associated with the specified Data Lake Analytics and Azure Storage account combination. The response includes a link to the next page of results, if any.
  ## 
  let valid = call_564281.validator(path, query, header, formData, body)
  let scheme = call_564281.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564281.url(scheme.get, call_564281.host, call_564281.base,
                         call_564281.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564281, url, valid)

proc call*(call_564282: Call_AccountListStorageContainers_564273;
          apiVersion: string; subscriptionId: string; resourceGroupName: string;
          storageAccountName: string; accountName: string): Recallable =
  ## accountListStorageContainers
  ## Lists the Azure Storage containers, if any, associated with the specified Data Lake Analytics and Azure Storage account combination. The response includes a link to the next page of results, if any.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Get subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the Azure resource group that contains the Data Lake Analytics account.
  ##   storageAccountName: string (required)
  ##                     : The name of the Azure storage account from which to list blob containers.
  ##   accountName: string (required)
  ##              : The name of the Data Lake Analytics account for which to list Azure Storage blob containers.
  var path_564283 = newJObject()
  var query_564284 = newJObject()
  add(query_564284, "api-version", newJString(apiVersion))
  add(path_564283, "subscriptionId", newJString(subscriptionId))
  add(path_564283, "resourceGroupName", newJString(resourceGroupName))
  add(path_564283, "storageAccountName", newJString(storageAccountName))
  add(path_564283, "accountName", newJString(accountName))
  result = call_564282.call(path_564283, query_564284, nil, nil, nil)

var accountListStorageContainers* = Call_AccountListStorageContainers_564273(
    name: "accountListStorageContainers", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataLakeAnalytics/accounts/{accountName}/StorageAccounts/{storageAccountName}/Containers",
    validator: validate_AccountListStorageContainers_564274, base: "",
    url: url_AccountListStorageContainers_564275, schemes: {Scheme.Https})
type
  Call_AccountGetStorageContainer_564285 = ref object of OpenApiRestCall_563539
proc url_AccountGetStorageContainer_564287(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "accountName" in path, "`accountName` is a required path parameter"
  assert "storageAccountName" in path,
        "`storageAccountName` is a required path parameter"
  assert "containerName" in path, "`containerName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.DataLakeAnalytics/accounts/"),
               (kind: VariableSegment, value: "accountName"),
               (kind: ConstantSegment, value: "/StorageAccounts/"),
               (kind: VariableSegment, value: "storageAccountName"),
               (kind: ConstantSegment, value: "/Containers/"),
               (kind: VariableSegment, value: "containerName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AccountGetStorageContainer_564286(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the specified Azure Storage container associated with the given Data Lake Analytics and Azure Storage accounts.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Get subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the Azure resource group that contains the Data Lake Analytics account.
  ##   containerName: JString (required)
  ##                : The name of the Azure storage container to retrieve
  ##   storageAccountName: JString (required)
  ##                     : The name of the Azure storage account from which to retrieve the blob container.
  ##   accountName: JString (required)
  ##              : The name of the Data Lake Analytics account for which to retrieve blob container.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564288 = path.getOrDefault("subscriptionId")
  valid_564288 = validateParameter(valid_564288, JString, required = true,
                                 default = nil)
  if valid_564288 != nil:
    section.add "subscriptionId", valid_564288
  var valid_564289 = path.getOrDefault("resourceGroupName")
  valid_564289 = validateParameter(valid_564289, JString, required = true,
                                 default = nil)
  if valid_564289 != nil:
    section.add "resourceGroupName", valid_564289
  var valid_564290 = path.getOrDefault("containerName")
  valid_564290 = validateParameter(valid_564290, JString, required = true,
                                 default = nil)
  if valid_564290 != nil:
    section.add "containerName", valid_564290
  var valid_564291 = path.getOrDefault("storageAccountName")
  valid_564291 = validateParameter(valid_564291, JString, required = true,
                                 default = nil)
  if valid_564291 != nil:
    section.add "storageAccountName", valid_564291
  var valid_564292 = path.getOrDefault("accountName")
  valid_564292 = validateParameter(valid_564292, JString, required = true,
                                 default = nil)
  if valid_564292 != nil:
    section.add "accountName", valid_564292
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564293 = query.getOrDefault("api-version")
  valid_564293 = validateParameter(valid_564293, JString, required = true,
                                 default = nil)
  if valid_564293 != nil:
    section.add "api-version", valid_564293
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564294: Call_AccountGetStorageContainer_564285; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the specified Azure Storage container associated with the given Data Lake Analytics and Azure Storage accounts.
  ## 
  let valid = call_564294.validator(path, query, header, formData, body)
  let scheme = call_564294.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564294.url(scheme.get, call_564294.host, call_564294.base,
                         call_564294.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564294, url, valid)

proc call*(call_564295: Call_AccountGetStorageContainer_564285; apiVersion: string;
          subscriptionId: string; resourceGroupName: string; containerName: string;
          storageAccountName: string; accountName: string): Recallable =
  ## accountGetStorageContainer
  ## Gets the specified Azure Storage container associated with the given Data Lake Analytics and Azure Storage accounts.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Get subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the Azure resource group that contains the Data Lake Analytics account.
  ##   containerName: string (required)
  ##                : The name of the Azure storage container to retrieve
  ##   storageAccountName: string (required)
  ##                     : The name of the Azure storage account from which to retrieve the blob container.
  ##   accountName: string (required)
  ##              : The name of the Data Lake Analytics account for which to retrieve blob container.
  var path_564296 = newJObject()
  var query_564297 = newJObject()
  add(query_564297, "api-version", newJString(apiVersion))
  add(path_564296, "subscriptionId", newJString(subscriptionId))
  add(path_564296, "resourceGroupName", newJString(resourceGroupName))
  add(path_564296, "containerName", newJString(containerName))
  add(path_564296, "storageAccountName", newJString(storageAccountName))
  add(path_564296, "accountName", newJString(accountName))
  result = call_564295.call(path_564296, query_564297, nil, nil, nil)

var accountGetStorageContainer* = Call_AccountGetStorageContainer_564285(
    name: "accountGetStorageContainer", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataLakeAnalytics/accounts/{accountName}/StorageAccounts/{storageAccountName}/Containers/{containerName}",
    validator: validate_AccountGetStorageContainer_564286, base: "",
    url: url_AccountGetStorageContainer_564287, schemes: {Scheme.Https})
type
  Call_AccountListSasTokens_564298 = ref object of OpenApiRestCall_563539
proc url_AccountListSasTokens_564300(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "accountName" in path, "`accountName` is a required path parameter"
  assert "storageAccountName" in path,
        "`storageAccountName` is a required path parameter"
  assert "containerName" in path, "`containerName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.DataLakeAnalytics/accounts/"),
               (kind: VariableSegment, value: "accountName"),
               (kind: ConstantSegment, value: "/StorageAccounts/"),
               (kind: VariableSegment, value: "storageAccountName"),
               (kind: ConstantSegment, value: "/Containers/"),
               (kind: VariableSegment, value: "containerName"),
               (kind: ConstantSegment, value: "/listSasTokens")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AccountListSasTokens_564299(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the SAS token associated with the specified Data Lake Analytics and Azure Storage account and container combination.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Get subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the Azure resource group that contains the Data Lake Analytics account.
  ##   containerName: JString (required)
  ##                : The name of the Azure storage container for which the SAS token is being requested.
  ##   storageAccountName: JString (required)
  ##                     : The name of the Azure storage account for which the SAS token is being requested.
  ##   accountName: JString (required)
  ##              : The name of the Data Lake Analytics account from which an Azure Storage account's SAS token is being requested.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564301 = path.getOrDefault("subscriptionId")
  valid_564301 = validateParameter(valid_564301, JString, required = true,
                                 default = nil)
  if valid_564301 != nil:
    section.add "subscriptionId", valid_564301
  var valid_564302 = path.getOrDefault("resourceGroupName")
  valid_564302 = validateParameter(valid_564302, JString, required = true,
                                 default = nil)
  if valid_564302 != nil:
    section.add "resourceGroupName", valid_564302
  var valid_564303 = path.getOrDefault("containerName")
  valid_564303 = validateParameter(valid_564303, JString, required = true,
                                 default = nil)
  if valid_564303 != nil:
    section.add "containerName", valid_564303
  var valid_564304 = path.getOrDefault("storageAccountName")
  valid_564304 = validateParameter(valid_564304, JString, required = true,
                                 default = nil)
  if valid_564304 != nil:
    section.add "storageAccountName", valid_564304
  var valid_564305 = path.getOrDefault("accountName")
  valid_564305 = validateParameter(valid_564305, JString, required = true,
                                 default = nil)
  if valid_564305 != nil:
    section.add "accountName", valid_564305
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564306 = query.getOrDefault("api-version")
  valid_564306 = validateParameter(valid_564306, JString, required = true,
                                 default = nil)
  if valid_564306 != nil:
    section.add "api-version", valid_564306
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564307: Call_AccountListSasTokens_564298; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the SAS token associated with the specified Data Lake Analytics and Azure Storage account and container combination.
  ## 
  let valid = call_564307.validator(path, query, header, formData, body)
  let scheme = call_564307.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564307.url(scheme.get, call_564307.host, call_564307.base,
                         call_564307.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564307, url, valid)

proc call*(call_564308: Call_AccountListSasTokens_564298; apiVersion: string;
          subscriptionId: string; resourceGroupName: string; containerName: string;
          storageAccountName: string; accountName: string): Recallable =
  ## accountListSasTokens
  ## Gets the SAS token associated with the specified Data Lake Analytics and Azure Storage account and container combination.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Get subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the Azure resource group that contains the Data Lake Analytics account.
  ##   containerName: string (required)
  ##                : The name of the Azure storage container for which the SAS token is being requested.
  ##   storageAccountName: string (required)
  ##                     : The name of the Azure storage account for which the SAS token is being requested.
  ##   accountName: string (required)
  ##              : The name of the Data Lake Analytics account from which an Azure Storage account's SAS token is being requested.
  var path_564309 = newJObject()
  var query_564310 = newJObject()
  add(query_564310, "api-version", newJString(apiVersion))
  add(path_564309, "subscriptionId", newJString(subscriptionId))
  add(path_564309, "resourceGroupName", newJString(resourceGroupName))
  add(path_564309, "containerName", newJString(containerName))
  add(path_564309, "storageAccountName", newJString(storageAccountName))
  add(path_564309, "accountName", newJString(accountName))
  result = call_564308.call(path_564309, query_564310, nil, nil, nil)

var accountListSasTokens* = Call_AccountListSasTokens_564298(
    name: "accountListSasTokens", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataLakeAnalytics/accounts/{accountName}/StorageAccounts/{storageAccountName}/Containers/{containerName}/listSasTokens",
    validator: validate_AccountListSasTokens_564299, base: "",
    url: url_AccountListSasTokens_564300, schemes: {Scheme.Https})
type
  Call_AccountCreate_564311 = ref object of OpenApiRestCall_563539
proc url_AccountCreate_564313(protocol: Scheme; host: string; base: string;
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
        value: "/providers/Microsoft.DataLakeAnalytics/accounts/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AccountCreate_564312(path: JsonNode; query: JsonNode; header: JsonNode;
                                  formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates the specified Data Lake Analytics account. This supplies the user with computation services for Data Lake Analytics workloads
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The name of the Data Lake Analytics account to create.
  ##   subscriptionId: JString (required)
  ##                 : Get subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the Azure resource group that contains the Data Lake Analytics account.the account will be associated with.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_564314 = path.getOrDefault("name")
  valid_564314 = validateParameter(valid_564314, JString, required = true,
                                 default = nil)
  if valid_564314 != nil:
    section.add "name", valid_564314
  var valid_564315 = path.getOrDefault("subscriptionId")
  valid_564315 = validateParameter(valid_564315, JString, required = true,
                                 default = nil)
  if valid_564315 != nil:
    section.add "subscriptionId", valid_564315
  var valid_564316 = path.getOrDefault("resourceGroupName")
  valid_564316 = validateParameter(valid_564316, JString, required = true,
                                 default = nil)
  if valid_564316 != nil:
    section.add "resourceGroupName", valid_564316
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564317 = query.getOrDefault("api-version")
  valid_564317 = validateParameter(valid_564317, JString, required = true,
                                 default = nil)
  if valid_564317 != nil:
    section.add "api-version", valid_564317
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the create Data Lake Analytics account operation.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564319: Call_AccountCreate_564311; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates the specified Data Lake Analytics account. This supplies the user with computation services for Data Lake Analytics workloads
  ## 
  let valid = call_564319.validator(path, query, header, formData, body)
  let scheme = call_564319.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564319.url(scheme.get, call_564319.host, call_564319.base,
                         call_564319.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564319, url, valid)

proc call*(call_564320: Call_AccountCreate_564311; apiVersion: string; name: string;
          subscriptionId: string; resourceGroupName: string; parameters: JsonNode): Recallable =
  ## accountCreate
  ## Creates the specified Data Lake Analytics account. This supplies the user with computation services for Data Lake Analytics workloads
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   name: string (required)
  ##       : The name of the Data Lake Analytics account to create.
  ##   subscriptionId: string (required)
  ##                 : Get subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the Azure resource group that contains the Data Lake Analytics account.the account will be associated with.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the create Data Lake Analytics account operation.
  var path_564321 = newJObject()
  var query_564322 = newJObject()
  var body_564323 = newJObject()
  add(query_564322, "api-version", newJString(apiVersion))
  add(path_564321, "name", newJString(name))
  add(path_564321, "subscriptionId", newJString(subscriptionId))
  add(path_564321, "resourceGroupName", newJString(resourceGroupName))
  if parameters != nil:
    body_564323 = parameters
  result = call_564320.call(path_564321, query_564322, nil, nil, body_564323)

var accountCreate* = Call_AccountCreate_564311(name: "accountCreate",
    meth: HttpMethod.HttpPut, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataLakeAnalytics/accounts/{name}",
    validator: validate_AccountCreate_564312, base: "", url: url_AccountCreate_564313,
    schemes: {Scheme.Https})
type
  Call_AccountUpdate_564324 = ref object of OpenApiRestCall_563539
proc url_AccountUpdate_564326(protocol: Scheme; host: string; base: string;
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
        value: "/providers/Microsoft.DataLakeAnalytics/accounts/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AccountUpdate_564325(path: JsonNode; query: JsonNode; header: JsonNode;
                                  formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates the Data Lake Analytics account object specified by the accountName with the contents of the account object.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The name of the Data Lake Analytics account to update.
  ##   subscriptionId: JString (required)
  ##                 : Get subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the Azure resource group that contains the Data Lake Analytics account.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_564327 = path.getOrDefault("name")
  valid_564327 = validateParameter(valid_564327, JString, required = true,
                                 default = nil)
  if valid_564327 != nil:
    section.add "name", valid_564327
  var valid_564328 = path.getOrDefault("subscriptionId")
  valid_564328 = validateParameter(valid_564328, JString, required = true,
                                 default = nil)
  if valid_564328 != nil:
    section.add "subscriptionId", valid_564328
  var valid_564329 = path.getOrDefault("resourceGroupName")
  valid_564329 = validateParameter(valid_564329, JString, required = true,
                                 default = nil)
  if valid_564329 != nil:
    section.add "resourceGroupName", valid_564329
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564330 = query.getOrDefault("api-version")
  valid_564330 = validateParameter(valid_564330, JString, required = true,
                                 default = nil)
  if valid_564330 != nil:
    section.add "api-version", valid_564330
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the update Data Lake Analytics account operation.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564332: Call_AccountUpdate_564324; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the Data Lake Analytics account object specified by the accountName with the contents of the account object.
  ## 
  let valid = call_564332.validator(path, query, header, formData, body)
  let scheme = call_564332.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564332.url(scheme.get, call_564332.host, call_564332.base,
                         call_564332.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564332, url, valid)

proc call*(call_564333: Call_AccountUpdate_564324; apiVersion: string; name: string;
          subscriptionId: string; resourceGroupName: string; parameters: JsonNode): Recallable =
  ## accountUpdate
  ## Updates the Data Lake Analytics account object specified by the accountName with the contents of the account object.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   name: string (required)
  ##       : The name of the Data Lake Analytics account to update.
  ##   subscriptionId: string (required)
  ##                 : Get subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the Azure resource group that contains the Data Lake Analytics account.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the update Data Lake Analytics account operation.
  var path_564334 = newJObject()
  var query_564335 = newJObject()
  var body_564336 = newJObject()
  add(query_564335, "api-version", newJString(apiVersion))
  add(path_564334, "name", newJString(name))
  add(path_564334, "subscriptionId", newJString(subscriptionId))
  add(path_564334, "resourceGroupName", newJString(resourceGroupName))
  if parameters != nil:
    body_564336 = parameters
  result = call_564333.call(path_564334, query_564335, nil, nil, body_564336)

var accountUpdate* = Call_AccountUpdate_564324(name: "accountUpdate",
    meth: HttpMethod.HttpPatch, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataLakeAnalytics/accounts/{name}",
    validator: validate_AccountUpdate_564325, base: "", url: url_AccountUpdate_564326,
    schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)

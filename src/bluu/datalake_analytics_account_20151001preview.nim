
import
  json, options, hashes, uri, rest, os, uri, strutils, httpcore

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

  OpenApiRestCall_567641 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_567641](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_567641): Option[Scheme] {.used.} =
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
    if js.kind notin {JString, JInt, JFloat, JNull, JBool}:
      return
    head = $js
  var remainder = input.hydratePath(segments[1 ..^ 1])
  if remainder.isNone:
    return
  result = some(head & remainder.get)

const
  macServiceName = "datalake-analytics-account"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_AccountList_567863 = ref object of OpenApiRestCall_567641
proc url_AccountList_567865(protocol: Scheme; host: string; base: string;
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

proc validate_AccountList_567864(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_568039 = path.getOrDefault("subscriptionId")
  valid_568039 = validateParameter(valid_568039, JString, required = true,
                                 default = nil)
  if valid_568039 != nil:
    section.add "subscriptionId", valid_568039
  result.add "path", section
  ## parameters in `query` object:
  ##   $orderby: JString
  ##           : OrderBy clause. One or more comma-separated expressions with an optional "asc" (the default) or "desc" depending on the order you'd like the values sorted, e.g. Categories?$orderby=CategoryName desc. Optional.
  ##   $expand: JString
  ##          : OData expansion. Expand related resources in line with the retrieved resources, e.g. Categories/$expand=Products would expand Product data in line with each Category entry. Optional.
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   $top: JInt
  ##       : The number of items to return. Optional.
  ##   $select: JString
  ##          : OData Select statement. Limits the properties on each entry to just those requested, e.g. Categories?$select=CategoryName,Description. Optional.
  ##   $skip: JInt
  ##        : The number of items to skip over before returning elements. Optional.
  ##   $count: JBool
  ##         : The Boolean value of true or false to request a count of the matching resources included with the resources in the response, e.g. Categories?$count=true. Optional.
  ##   $search: JString
  ##          : A free form search. A free-text search expression to match for whether a particular entry should be included in the feed, e.g. Categories?$search=blue OR green. Optional.
  ##   $format: JString
  ##          : The desired return format. Return the response in particular format without access to request headers for standard content-type negotiation (e.g Orders?$format=json). Optional.
  ##   $filter: JString
  ##          : OData filter. Optional.
  section = newJObject()
  var valid_568040 = query.getOrDefault("$orderby")
  valid_568040 = validateParameter(valid_568040, JString, required = false,
                                 default = nil)
  if valid_568040 != nil:
    section.add "$orderby", valid_568040
  var valid_568041 = query.getOrDefault("$expand")
  valid_568041 = validateParameter(valid_568041, JString, required = false,
                                 default = nil)
  if valid_568041 != nil:
    section.add "$expand", valid_568041
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568042 = query.getOrDefault("api-version")
  valid_568042 = validateParameter(valid_568042, JString, required = true,
                                 default = nil)
  if valid_568042 != nil:
    section.add "api-version", valid_568042
  var valid_568043 = query.getOrDefault("$top")
  valid_568043 = validateParameter(valid_568043, JInt, required = false, default = nil)
  if valid_568043 != nil:
    section.add "$top", valid_568043
  var valid_568044 = query.getOrDefault("$select")
  valid_568044 = validateParameter(valid_568044, JString, required = false,
                                 default = nil)
  if valid_568044 != nil:
    section.add "$select", valid_568044
  var valid_568045 = query.getOrDefault("$skip")
  valid_568045 = validateParameter(valid_568045, JInt, required = false, default = nil)
  if valid_568045 != nil:
    section.add "$skip", valid_568045
  var valid_568046 = query.getOrDefault("$count")
  valid_568046 = validateParameter(valid_568046, JBool, required = false, default = nil)
  if valid_568046 != nil:
    section.add "$count", valid_568046
  var valid_568047 = query.getOrDefault("$search")
  valid_568047 = validateParameter(valid_568047, JString, required = false,
                                 default = nil)
  if valid_568047 != nil:
    section.add "$search", valid_568047
  var valid_568048 = query.getOrDefault("$format")
  valid_568048 = validateParameter(valid_568048, JString, required = false,
                                 default = nil)
  if valid_568048 != nil:
    section.add "$format", valid_568048
  var valid_568049 = query.getOrDefault("$filter")
  valid_568049 = validateParameter(valid_568049, JString, required = false,
                                 default = nil)
  if valid_568049 != nil:
    section.add "$filter", valid_568049
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568072: Call_AccountList_567863; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the first page of Data Lake Analytics accounts, if any, within the current subscription. This includes a link to the next page, if any.
  ## 
  let valid = call_568072.validator(path, query, header, formData, body)
  let scheme = call_568072.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568072.url(scheme.get, call_568072.host, call_568072.base,
                         call_568072.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568072, url, valid)

proc call*(call_568143: Call_AccountList_567863; apiVersion: string;
          subscriptionId: string; Orderby: string = ""; Expand: string = ""; Top: int = 0;
          Select: string = ""; Skip: int = 0; Count: bool = false; Search: string = "";
          Format: string = ""; Filter: string = ""): Recallable =
  ## accountList
  ## Gets the first page of Data Lake Analytics accounts, if any, within the current subscription. This includes a link to the next page, if any.
  ##   Orderby: string
  ##          : OrderBy clause. One or more comma-separated expressions with an optional "asc" (the default) or "desc" depending on the order you'd like the values sorted, e.g. Categories?$orderby=CategoryName desc. Optional.
  ##   Expand: string
  ##         : OData expansion. Expand related resources in line with the retrieved resources, e.g. Categories/$expand=Products would expand Product data in line with each Category entry. Optional.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Get subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   Top: int
  ##      : The number of items to return. Optional.
  ##   Select: string
  ##         : OData Select statement. Limits the properties on each entry to just those requested, e.g. Categories?$select=CategoryName,Description. Optional.
  ##   Skip: int
  ##       : The number of items to skip over before returning elements. Optional.
  ##   Count: bool
  ##        : The Boolean value of true or false to request a count of the matching resources included with the resources in the response, e.g. Categories?$count=true. Optional.
  ##   Search: string
  ##         : A free form search. A free-text search expression to match for whether a particular entry should be included in the feed, e.g. Categories?$search=blue OR green. Optional.
  ##   Format: string
  ##         : The desired return format. Return the response in particular format without access to request headers for standard content-type negotiation (e.g Orders?$format=json). Optional.
  ##   Filter: string
  ##         : OData filter. Optional.
  var path_568144 = newJObject()
  var query_568146 = newJObject()
  add(query_568146, "$orderby", newJString(Orderby))
  add(query_568146, "$expand", newJString(Expand))
  add(query_568146, "api-version", newJString(apiVersion))
  add(path_568144, "subscriptionId", newJString(subscriptionId))
  add(query_568146, "$top", newJInt(Top))
  add(query_568146, "$select", newJString(Select))
  add(query_568146, "$skip", newJInt(Skip))
  add(query_568146, "$count", newJBool(Count))
  add(query_568146, "$search", newJString(Search))
  add(query_568146, "$format", newJString(Format))
  add(query_568146, "$filter", newJString(Filter))
  result = call_568143.call(path_568144, query_568146, nil, nil, nil)

var accountList* = Call_AccountList_567863(name: "accountList",
                                        meth: HttpMethod.HttpGet,
                                        host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.DataLakeAnalytics/accounts",
                                        validator: validate_AccountList_567864,
                                        base: "", url: url_AccountList_567865,
                                        schemes: {Scheme.Https})
type
  Call_AccountListByResourceGroup_568185 = ref object of OpenApiRestCall_567641
proc url_AccountListByResourceGroup_568187(protocol: Scheme; host: string;
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

proc validate_AccountListByResourceGroup_568186(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the first page of Data Lake Analytics accounts, if any, within a specific resource group. This includes a link to the next page, if any.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the Azure resource group that contains the Data Lake Analytics account.
  ##   subscriptionId: JString (required)
  ##                 : Get subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568188 = path.getOrDefault("resourceGroupName")
  valid_568188 = validateParameter(valid_568188, JString, required = true,
                                 default = nil)
  if valid_568188 != nil:
    section.add "resourceGroupName", valid_568188
  var valid_568189 = path.getOrDefault("subscriptionId")
  valid_568189 = validateParameter(valid_568189, JString, required = true,
                                 default = nil)
  if valid_568189 != nil:
    section.add "subscriptionId", valid_568189
  result.add "path", section
  ## parameters in `query` object:
  ##   $orderby: JString
  ##           : OrderBy clause. One or more comma-separated expressions with an optional "asc" (the default) or "desc" depending on the order you'd like the values sorted, e.g. Categories?$orderby=CategoryName desc. Optional.
  ##   $expand: JString
  ##          : OData expansion. Expand related resources in line with the retrieved resources, e.g. Categories/$expand=Products would expand Product data in line with each Category entry. Optional.
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   $top: JInt
  ##       : The number of items to return. Optional.
  ##   $select: JString
  ##          : OData Select statement. Limits the properties on each entry to just those requested, e.g. Categories?$select=CategoryName,Description. Optional.
  ##   $skip: JInt
  ##        : The number of items to skip over before returning elements. Optional.
  ##   $count: JBool
  ##         : The Boolean value of true or false to request a count of the matching resources included with the resources in the response, e.g. Categories?$count=true. Optional.
  ##   $search: JString
  ##          : A free form search. A free-text search expression to match for whether a particular entry should be included in the feed, e.g. Categories?$search=blue OR green. Optional.
  ##   $format: JString
  ##          : The return format. Return the response in particular format without access to request headers for standard content-type negotiation (e.g Orders?$format=json). Optional.
  ##   $filter: JString
  ##          : OData filter. Optional.
  section = newJObject()
  var valid_568190 = query.getOrDefault("$orderby")
  valid_568190 = validateParameter(valid_568190, JString, required = false,
                                 default = nil)
  if valid_568190 != nil:
    section.add "$orderby", valid_568190
  var valid_568191 = query.getOrDefault("$expand")
  valid_568191 = validateParameter(valid_568191, JString, required = false,
                                 default = nil)
  if valid_568191 != nil:
    section.add "$expand", valid_568191
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568192 = query.getOrDefault("api-version")
  valid_568192 = validateParameter(valid_568192, JString, required = true,
                                 default = nil)
  if valid_568192 != nil:
    section.add "api-version", valid_568192
  var valid_568193 = query.getOrDefault("$top")
  valid_568193 = validateParameter(valid_568193, JInt, required = false, default = nil)
  if valid_568193 != nil:
    section.add "$top", valid_568193
  var valid_568194 = query.getOrDefault("$select")
  valid_568194 = validateParameter(valid_568194, JString, required = false,
                                 default = nil)
  if valid_568194 != nil:
    section.add "$select", valid_568194
  var valid_568195 = query.getOrDefault("$skip")
  valid_568195 = validateParameter(valid_568195, JInt, required = false, default = nil)
  if valid_568195 != nil:
    section.add "$skip", valid_568195
  var valid_568196 = query.getOrDefault("$count")
  valid_568196 = validateParameter(valid_568196, JBool, required = false, default = nil)
  if valid_568196 != nil:
    section.add "$count", valid_568196
  var valid_568197 = query.getOrDefault("$search")
  valid_568197 = validateParameter(valid_568197, JString, required = false,
                                 default = nil)
  if valid_568197 != nil:
    section.add "$search", valid_568197
  var valid_568198 = query.getOrDefault("$format")
  valid_568198 = validateParameter(valid_568198, JString, required = false,
                                 default = nil)
  if valid_568198 != nil:
    section.add "$format", valid_568198
  var valid_568199 = query.getOrDefault("$filter")
  valid_568199 = validateParameter(valid_568199, JString, required = false,
                                 default = nil)
  if valid_568199 != nil:
    section.add "$filter", valid_568199
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568200: Call_AccountListByResourceGroup_568185; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the first page of Data Lake Analytics accounts, if any, within a specific resource group. This includes a link to the next page, if any.
  ## 
  let valid = call_568200.validator(path, query, header, formData, body)
  let scheme = call_568200.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568200.url(scheme.get, call_568200.host, call_568200.base,
                         call_568200.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568200, url, valid)

proc call*(call_568201: Call_AccountListByResourceGroup_568185;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          Orderby: string = ""; Expand: string = ""; Top: int = 0; Select: string = "";
          Skip: int = 0; Count: bool = false; Search: string = ""; Format: string = "";
          Filter: string = ""): Recallable =
  ## accountListByResourceGroup
  ## Gets the first page of Data Lake Analytics accounts, if any, within a specific resource group. This includes a link to the next page, if any.
  ##   Orderby: string
  ##          : OrderBy clause. One or more comma-separated expressions with an optional "asc" (the default) or "desc" depending on the order you'd like the values sorted, e.g. Categories?$orderby=CategoryName desc. Optional.
  ##   resourceGroupName: string (required)
  ##                    : The name of the Azure resource group that contains the Data Lake Analytics account.
  ##   Expand: string
  ##         : OData expansion. Expand related resources in line with the retrieved resources, e.g. Categories/$expand=Products would expand Product data in line with each Category entry. Optional.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Get subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   Top: int
  ##      : The number of items to return. Optional.
  ##   Select: string
  ##         : OData Select statement. Limits the properties on each entry to just those requested, e.g. Categories?$select=CategoryName,Description. Optional.
  ##   Skip: int
  ##       : The number of items to skip over before returning elements. Optional.
  ##   Count: bool
  ##        : The Boolean value of true or false to request a count of the matching resources included with the resources in the response, e.g. Categories?$count=true. Optional.
  ##   Search: string
  ##         : A free form search. A free-text search expression to match for whether a particular entry should be included in the feed, e.g. Categories?$search=blue OR green. Optional.
  ##   Format: string
  ##         : The return format. Return the response in particular format without access to request headers for standard content-type negotiation (e.g Orders?$format=json). Optional.
  ##   Filter: string
  ##         : OData filter. Optional.
  var path_568202 = newJObject()
  var query_568203 = newJObject()
  add(query_568203, "$orderby", newJString(Orderby))
  add(path_568202, "resourceGroupName", newJString(resourceGroupName))
  add(query_568203, "$expand", newJString(Expand))
  add(query_568203, "api-version", newJString(apiVersion))
  add(path_568202, "subscriptionId", newJString(subscriptionId))
  add(query_568203, "$top", newJInt(Top))
  add(query_568203, "$select", newJString(Select))
  add(query_568203, "$skip", newJInt(Skip))
  add(query_568203, "$count", newJBool(Count))
  add(query_568203, "$search", newJString(Search))
  add(query_568203, "$format", newJString(Format))
  add(query_568203, "$filter", newJString(Filter))
  result = call_568201.call(path_568202, query_568203, nil, nil, nil)

var accountListByResourceGroup* = Call_AccountListByResourceGroup_568185(
    name: "accountListByResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataLakeAnalytics/accounts",
    validator: validate_AccountListByResourceGroup_568186, base: "",
    url: url_AccountListByResourceGroup_568187, schemes: {Scheme.Https})
type
  Call_AccountGet_568204 = ref object of OpenApiRestCall_567641
proc url_AccountGet_568206(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_AccountGet_568205(path: JsonNode; query: JsonNode; header: JsonNode;
                               formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets details of the specified Data Lake Analytics account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the Azure resource group that contains the Data Lake Analytics account.
  ##   subscriptionId: JString (required)
  ##                 : Get subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   accountName: JString (required)
  ##              : The name of the Data Lake Analytics account to retrieve.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568207 = path.getOrDefault("resourceGroupName")
  valid_568207 = validateParameter(valid_568207, JString, required = true,
                                 default = nil)
  if valid_568207 != nil:
    section.add "resourceGroupName", valid_568207
  var valid_568208 = path.getOrDefault("subscriptionId")
  valid_568208 = validateParameter(valid_568208, JString, required = true,
                                 default = nil)
  if valid_568208 != nil:
    section.add "subscriptionId", valid_568208
  var valid_568209 = path.getOrDefault("accountName")
  valid_568209 = validateParameter(valid_568209, JString, required = true,
                                 default = nil)
  if valid_568209 != nil:
    section.add "accountName", valid_568209
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568210 = query.getOrDefault("api-version")
  valid_568210 = validateParameter(valid_568210, JString, required = true,
                                 default = nil)
  if valid_568210 != nil:
    section.add "api-version", valid_568210
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568211: Call_AccountGet_568204; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets details of the specified Data Lake Analytics account.
  ## 
  let valid = call_568211.validator(path, query, header, formData, body)
  let scheme = call_568211.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568211.url(scheme.get, call_568211.host, call_568211.base,
                         call_568211.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568211, url, valid)

proc call*(call_568212: Call_AccountGet_568204; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; accountName: string): Recallable =
  ## accountGet
  ## Gets details of the specified Data Lake Analytics account.
  ##   resourceGroupName: string (required)
  ##                    : The name of the Azure resource group that contains the Data Lake Analytics account.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Get subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   accountName: string (required)
  ##              : The name of the Data Lake Analytics account to retrieve.
  var path_568213 = newJObject()
  var query_568214 = newJObject()
  add(path_568213, "resourceGroupName", newJString(resourceGroupName))
  add(query_568214, "api-version", newJString(apiVersion))
  add(path_568213, "subscriptionId", newJString(subscriptionId))
  add(path_568213, "accountName", newJString(accountName))
  result = call_568212.call(path_568213, query_568214, nil, nil, nil)

var accountGet* = Call_AccountGet_568204(name: "accountGet",
                                      meth: HttpMethod.HttpGet,
                                      host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataLakeAnalytics/accounts/{accountName}",
                                      validator: validate_AccountGet_568205,
                                      base: "", url: url_AccountGet_568206,
                                      schemes: {Scheme.Https})
type
  Call_AccountDelete_568215 = ref object of OpenApiRestCall_567641
proc url_AccountDelete_568217(protocol: Scheme; host: string; base: string;
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

proc validate_AccountDelete_568216(path: JsonNode; query: JsonNode; header: JsonNode;
                                  formData: JsonNode; body: JsonNode): JsonNode =
  ## Begins the delete process for the Data Lake Analytics account object specified by the account name.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the Azure resource group that contains the Data Lake Analytics account.
  ##   subscriptionId: JString (required)
  ##                 : Get subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   accountName: JString (required)
  ##              : The name of the Data Lake Analytics account to delete
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568218 = path.getOrDefault("resourceGroupName")
  valid_568218 = validateParameter(valid_568218, JString, required = true,
                                 default = nil)
  if valid_568218 != nil:
    section.add "resourceGroupName", valid_568218
  var valid_568219 = path.getOrDefault("subscriptionId")
  valid_568219 = validateParameter(valid_568219, JString, required = true,
                                 default = nil)
  if valid_568219 != nil:
    section.add "subscriptionId", valid_568219
  var valid_568220 = path.getOrDefault("accountName")
  valid_568220 = validateParameter(valid_568220, JString, required = true,
                                 default = nil)
  if valid_568220 != nil:
    section.add "accountName", valid_568220
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568221 = query.getOrDefault("api-version")
  valid_568221 = validateParameter(valid_568221, JString, required = true,
                                 default = nil)
  if valid_568221 != nil:
    section.add "api-version", valid_568221
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568222: Call_AccountDelete_568215; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Begins the delete process for the Data Lake Analytics account object specified by the account name.
  ## 
  let valid = call_568222.validator(path, query, header, formData, body)
  let scheme = call_568222.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568222.url(scheme.get, call_568222.host, call_568222.base,
                         call_568222.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568222, url, valid)

proc call*(call_568223: Call_AccountDelete_568215; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; accountName: string): Recallable =
  ## accountDelete
  ## Begins the delete process for the Data Lake Analytics account object specified by the account name.
  ##   resourceGroupName: string (required)
  ##                    : The name of the Azure resource group that contains the Data Lake Analytics account.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Get subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   accountName: string (required)
  ##              : The name of the Data Lake Analytics account to delete
  var path_568224 = newJObject()
  var query_568225 = newJObject()
  add(path_568224, "resourceGroupName", newJString(resourceGroupName))
  add(query_568225, "api-version", newJString(apiVersion))
  add(path_568224, "subscriptionId", newJString(subscriptionId))
  add(path_568224, "accountName", newJString(accountName))
  result = call_568223.call(path_568224, query_568225, nil, nil, nil)

var accountDelete* = Call_AccountDelete_568215(name: "accountDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataLakeAnalytics/accounts/{accountName}",
    validator: validate_AccountDelete_568216, base: "", url: url_AccountDelete_568217,
    schemes: {Scheme.Https})
type
  Call_AccountListDataLakeStoreAccounts_568226 = ref object of OpenApiRestCall_567641
proc url_AccountListDataLakeStoreAccounts_568228(protocol: Scheme; host: string;
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

proc validate_AccountListDataLakeStoreAccounts_568227(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the first page of Data Lake Store accounts linked to the specified Data Lake Analytics account. The response includes a link to the next page, if any.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the Azure resource group that contains the Data Lake Analytics account.
  ##   subscriptionId: JString (required)
  ##                 : Get subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   accountName: JString (required)
  ##              : The name of the Data Lake Analytics account for which to list Data Lake Store accounts.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568229 = path.getOrDefault("resourceGroupName")
  valid_568229 = validateParameter(valid_568229, JString, required = true,
                                 default = nil)
  if valid_568229 != nil:
    section.add "resourceGroupName", valid_568229
  var valid_568230 = path.getOrDefault("subscriptionId")
  valid_568230 = validateParameter(valid_568230, JString, required = true,
                                 default = nil)
  if valid_568230 != nil:
    section.add "subscriptionId", valid_568230
  var valid_568231 = path.getOrDefault("accountName")
  valid_568231 = validateParameter(valid_568231, JString, required = true,
                                 default = nil)
  if valid_568231 != nil:
    section.add "accountName", valid_568231
  result.add "path", section
  ## parameters in `query` object:
  ##   $orderby: JString
  ##           : OrderBy clause. One or more comma-separated expressions with an optional "asc" (the default) or "desc" depending on the order you'd like the values sorted, e.g. Categories?$orderby=CategoryName desc. Optional.
  ##   $expand: JString
  ##          : OData expansion. Expand related resources in line with the retrieved resources, e.g. Categories/$expand=Products would expand Product data in line with each Category entry. Optional.
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   $top: JInt
  ##       : The number of items to return. Optional.
  ##   $select: JString
  ##          : OData Select statement. Limits the properties on each entry to just those requested, e.g. Categories?$select=CategoryName,Description. Optional.
  ##   $skip: JInt
  ##        : The number of items to skip over before returning elements. Optional.
  ##   $count: JBool
  ##         : The Boolean value of true or false to request a count of the matching resources included with the resources in the response, e.g. Categories?$count=true. Optional.
  ##   $search: JString
  ##          : A free form search. A free-text search expression to match for whether a particular entry should be included in the feed, e.g. Categories?$search=blue OR green. Optional.
  ##   $format: JString
  ##          : The desired return format. Return the response in particular format without access to request headers for standard content-type negotiation (e.g Orders?$format=json). Optional.
  ##   $filter: JString
  ##          : OData filter. Optional.
  section = newJObject()
  var valid_568232 = query.getOrDefault("$orderby")
  valid_568232 = validateParameter(valid_568232, JString, required = false,
                                 default = nil)
  if valid_568232 != nil:
    section.add "$orderby", valid_568232
  var valid_568233 = query.getOrDefault("$expand")
  valid_568233 = validateParameter(valid_568233, JString, required = false,
                                 default = nil)
  if valid_568233 != nil:
    section.add "$expand", valid_568233
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568234 = query.getOrDefault("api-version")
  valid_568234 = validateParameter(valid_568234, JString, required = true,
                                 default = nil)
  if valid_568234 != nil:
    section.add "api-version", valid_568234
  var valid_568235 = query.getOrDefault("$top")
  valid_568235 = validateParameter(valid_568235, JInt, required = false, default = nil)
  if valid_568235 != nil:
    section.add "$top", valid_568235
  var valid_568236 = query.getOrDefault("$select")
  valid_568236 = validateParameter(valid_568236, JString, required = false,
                                 default = nil)
  if valid_568236 != nil:
    section.add "$select", valid_568236
  var valid_568237 = query.getOrDefault("$skip")
  valid_568237 = validateParameter(valid_568237, JInt, required = false, default = nil)
  if valid_568237 != nil:
    section.add "$skip", valid_568237
  var valid_568238 = query.getOrDefault("$count")
  valid_568238 = validateParameter(valid_568238, JBool, required = false, default = nil)
  if valid_568238 != nil:
    section.add "$count", valid_568238
  var valid_568239 = query.getOrDefault("$search")
  valid_568239 = validateParameter(valid_568239, JString, required = false,
                                 default = nil)
  if valid_568239 != nil:
    section.add "$search", valid_568239
  var valid_568240 = query.getOrDefault("$format")
  valid_568240 = validateParameter(valid_568240, JString, required = false,
                                 default = nil)
  if valid_568240 != nil:
    section.add "$format", valid_568240
  var valid_568241 = query.getOrDefault("$filter")
  valid_568241 = validateParameter(valid_568241, JString, required = false,
                                 default = nil)
  if valid_568241 != nil:
    section.add "$filter", valid_568241
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568242: Call_AccountListDataLakeStoreAccounts_568226;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the first page of Data Lake Store accounts linked to the specified Data Lake Analytics account. The response includes a link to the next page, if any.
  ## 
  let valid = call_568242.validator(path, query, header, formData, body)
  let scheme = call_568242.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568242.url(scheme.get, call_568242.host, call_568242.base,
                         call_568242.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568242, url, valid)

proc call*(call_568243: Call_AccountListDataLakeStoreAccounts_568226;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          accountName: string; Orderby: string = ""; Expand: string = ""; Top: int = 0;
          Select: string = ""; Skip: int = 0; Count: bool = false; Search: string = "";
          Format: string = ""; Filter: string = ""): Recallable =
  ## accountListDataLakeStoreAccounts
  ## Gets the first page of Data Lake Store accounts linked to the specified Data Lake Analytics account. The response includes a link to the next page, if any.
  ##   Orderby: string
  ##          : OrderBy clause. One or more comma-separated expressions with an optional "asc" (the default) or "desc" depending on the order you'd like the values sorted, e.g. Categories?$orderby=CategoryName desc. Optional.
  ##   resourceGroupName: string (required)
  ##                    : The name of the Azure resource group that contains the Data Lake Analytics account.
  ##   Expand: string
  ##         : OData expansion. Expand related resources in line with the retrieved resources, e.g. Categories/$expand=Products would expand Product data in line with each Category entry. Optional.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Get subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   Top: int
  ##      : The number of items to return. Optional.
  ##   Select: string
  ##         : OData Select statement. Limits the properties on each entry to just those requested, e.g. Categories?$select=CategoryName,Description. Optional.
  ##   Skip: int
  ##       : The number of items to skip over before returning elements. Optional.
  ##   Count: bool
  ##        : The Boolean value of true or false to request a count of the matching resources included with the resources in the response, e.g. Categories?$count=true. Optional.
  ##   Search: string
  ##         : A free form search. A free-text search expression to match for whether a particular entry should be included in the feed, e.g. Categories?$search=blue OR green. Optional.
  ##   Format: string
  ##         : The desired return format. Return the response in particular format without access to request headers for standard content-type negotiation (e.g Orders?$format=json). Optional.
  ##   accountName: string (required)
  ##              : The name of the Data Lake Analytics account for which to list Data Lake Store accounts.
  ##   Filter: string
  ##         : OData filter. Optional.
  var path_568244 = newJObject()
  var query_568245 = newJObject()
  add(query_568245, "$orderby", newJString(Orderby))
  add(path_568244, "resourceGroupName", newJString(resourceGroupName))
  add(query_568245, "$expand", newJString(Expand))
  add(query_568245, "api-version", newJString(apiVersion))
  add(path_568244, "subscriptionId", newJString(subscriptionId))
  add(query_568245, "$top", newJInt(Top))
  add(query_568245, "$select", newJString(Select))
  add(query_568245, "$skip", newJInt(Skip))
  add(query_568245, "$count", newJBool(Count))
  add(query_568245, "$search", newJString(Search))
  add(query_568245, "$format", newJString(Format))
  add(path_568244, "accountName", newJString(accountName))
  add(query_568245, "$filter", newJString(Filter))
  result = call_568243.call(path_568244, query_568245, nil, nil, nil)

var accountListDataLakeStoreAccounts* = Call_AccountListDataLakeStoreAccounts_568226(
    name: "accountListDataLakeStoreAccounts", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataLakeAnalytics/accounts/{accountName}/DataLakeStoreAccounts/",
    validator: validate_AccountListDataLakeStoreAccounts_568227, base: "",
    url: url_AccountListDataLakeStoreAccounts_568228, schemes: {Scheme.Https})
type
  Call_AccountAddDataLakeStoreAccount_568258 = ref object of OpenApiRestCall_567641
proc url_AccountAddDataLakeStoreAccount_568260(protocol: Scheme; host: string;
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

proc validate_AccountAddDataLakeStoreAccount_568259(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates the specified Data Lake Analytics account to include the additional Data Lake Store account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the Azure resource group that contains the Data Lake Analytics account.
  ##   subscriptionId: JString (required)
  ##                 : Get subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   dataLakeStoreAccountName: JString (required)
  ##                           : The name of the Data Lake Store account to add.
  ##   accountName: JString (required)
  ##              : The name of the Data Lake Analytics account to which to add the Data Lake Store account.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568278 = path.getOrDefault("resourceGroupName")
  valid_568278 = validateParameter(valid_568278, JString, required = true,
                                 default = nil)
  if valid_568278 != nil:
    section.add "resourceGroupName", valid_568278
  var valid_568279 = path.getOrDefault("subscriptionId")
  valid_568279 = validateParameter(valid_568279, JString, required = true,
                                 default = nil)
  if valid_568279 != nil:
    section.add "subscriptionId", valid_568279
  var valid_568280 = path.getOrDefault("dataLakeStoreAccountName")
  valid_568280 = validateParameter(valid_568280, JString, required = true,
                                 default = nil)
  if valid_568280 != nil:
    section.add "dataLakeStoreAccountName", valid_568280
  var valid_568281 = path.getOrDefault("accountName")
  valid_568281 = validateParameter(valid_568281, JString, required = true,
                                 default = nil)
  if valid_568281 != nil:
    section.add "accountName", valid_568281
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568282 = query.getOrDefault("api-version")
  valid_568282 = validateParameter(valid_568282, JString, required = true,
                                 default = nil)
  if valid_568282 != nil:
    section.add "api-version", valid_568282
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

proc call*(call_568284: Call_AccountAddDataLakeStoreAccount_568258; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the specified Data Lake Analytics account to include the additional Data Lake Store account.
  ## 
  let valid = call_568284.validator(path, query, header, formData, body)
  let scheme = call_568284.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568284.url(scheme.get, call_568284.host, call_568284.base,
                         call_568284.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568284, url, valid)

proc call*(call_568285: Call_AccountAddDataLakeStoreAccount_568258;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          parameters: JsonNode; dataLakeStoreAccountName: string;
          accountName: string): Recallable =
  ## accountAddDataLakeStoreAccount
  ## Updates the specified Data Lake Analytics account to include the additional Data Lake Store account.
  ##   resourceGroupName: string (required)
  ##                    : The name of the Azure resource group that contains the Data Lake Analytics account.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Get subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   parameters: JObject (required)
  ##             : The details of the Data Lake Store account.
  ##   dataLakeStoreAccountName: string (required)
  ##                           : The name of the Data Lake Store account to add.
  ##   accountName: string (required)
  ##              : The name of the Data Lake Analytics account to which to add the Data Lake Store account.
  var path_568286 = newJObject()
  var query_568287 = newJObject()
  var body_568288 = newJObject()
  add(path_568286, "resourceGroupName", newJString(resourceGroupName))
  add(query_568287, "api-version", newJString(apiVersion))
  add(path_568286, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_568288 = parameters
  add(path_568286, "dataLakeStoreAccountName",
      newJString(dataLakeStoreAccountName))
  add(path_568286, "accountName", newJString(accountName))
  result = call_568285.call(path_568286, query_568287, nil, nil, body_568288)

var accountAddDataLakeStoreAccount* = Call_AccountAddDataLakeStoreAccount_568258(
    name: "accountAddDataLakeStoreAccount", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataLakeAnalytics/accounts/{accountName}/DataLakeStoreAccounts/{dataLakeStoreAccountName}",
    validator: validate_AccountAddDataLakeStoreAccount_568259, base: "",
    url: url_AccountAddDataLakeStoreAccount_568260, schemes: {Scheme.Https})
type
  Call_AccountGetDataLakeStoreAccount_568246 = ref object of OpenApiRestCall_567641
proc url_AccountGetDataLakeStoreAccount_568248(protocol: Scheme; host: string;
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

proc validate_AccountGetDataLakeStoreAccount_568247(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the specified Data Lake Store account details in the specified Data Lake Analytics account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the Azure resource group that contains the Data Lake Analytics account.
  ##   subscriptionId: JString (required)
  ##                 : Get subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   dataLakeStoreAccountName: JString (required)
  ##                           : The name of the Data Lake Store account to retrieve
  ##   accountName: JString (required)
  ##              : The name of the Data Lake Analytics account from which to retrieve the Data Lake Store account details.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568249 = path.getOrDefault("resourceGroupName")
  valid_568249 = validateParameter(valid_568249, JString, required = true,
                                 default = nil)
  if valid_568249 != nil:
    section.add "resourceGroupName", valid_568249
  var valid_568250 = path.getOrDefault("subscriptionId")
  valid_568250 = validateParameter(valid_568250, JString, required = true,
                                 default = nil)
  if valid_568250 != nil:
    section.add "subscriptionId", valid_568250
  var valid_568251 = path.getOrDefault("dataLakeStoreAccountName")
  valid_568251 = validateParameter(valid_568251, JString, required = true,
                                 default = nil)
  if valid_568251 != nil:
    section.add "dataLakeStoreAccountName", valid_568251
  var valid_568252 = path.getOrDefault("accountName")
  valid_568252 = validateParameter(valid_568252, JString, required = true,
                                 default = nil)
  if valid_568252 != nil:
    section.add "accountName", valid_568252
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568253 = query.getOrDefault("api-version")
  valid_568253 = validateParameter(valid_568253, JString, required = true,
                                 default = nil)
  if valid_568253 != nil:
    section.add "api-version", valid_568253
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568254: Call_AccountGetDataLakeStoreAccount_568246; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the specified Data Lake Store account details in the specified Data Lake Analytics account.
  ## 
  let valid = call_568254.validator(path, query, header, formData, body)
  let scheme = call_568254.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568254.url(scheme.get, call_568254.host, call_568254.base,
                         call_568254.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568254, url, valid)

proc call*(call_568255: Call_AccountGetDataLakeStoreAccount_568246;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          dataLakeStoreAccountName: string; accountName: string): Recallable =
  ## accountGetDataLakeStoreAccount
  ## Gets the specified Data Lake Store account details in the specified Data Lake Analytics account.
  ##   resourceGroupName: string (required)
  ##                    : The name of the Azure resource group that contains the Data Lake Analytics account.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Get subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   dataLakeStoreAccountName: string (required)
  ##                           : The name of the Data Lake Store account to retrieve
  ##   accountName: string (required)
  ##              : The name of the Data Lake Analytics account from which to retrieve the Data Lake Store account details.
  var path_568256 = newJObject()
  var query_568257 = newJObject()
  add(path_568256, "resourceGroupName", newJString(resourceGroupName))
  add(query_568257, "api-version", newJString(apiVersion))
  add(path_568256, "subscriptionId", newJString(subscriptionId))
  add(path_568256, "dataLakeStoreAccountName",
      newJString(dataLakeStoreAccountName))
  add(path_568256, "accountName", newJString(accountName))
  result = call_568255.call(path_568256, query_568257, nil, nil, nil)

var accountGetDataLakeStoreAccount* = Call_AccountGetDataLakeStoreAccount_568246(
    name: "accountGetDataLakeStoreAccount", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataLakeAnalytics/accounts/{accountName}/DataLakeStoreAccounts/{dataLakeStoreAccountName}",
    validator: validate_AccountGetDataLakeStoreAccount_568247, base: "",
    url: url_AccountGetDataLakeStoreAccount_568248, schemes: {Scheme.Https})
type
  Call_AccountDeleteDataLakeStoreAccount_568289 = ref object of OpenApiRestCall_567641
proc url_AccountDeleteDataLakeStoreAccount_568291(protocol: Scheme; host: string;
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

proc validate_AccountDeleteDataLakeStoreAccount_568290(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates the Data Lake Analytics account specified to remove the specified Data Lake Store account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the Azure resource group that contains the Data Lake Analytics account.
  ##   subscriptionId: JString (required)
  ##                 : Get subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   dataLakeStoreAccountName: JString (required)
  ##                           : The name of the Data Lake Store account to remove
  ##   accountName: JString (required)
  ##              : The name of the Data Lake Analytics account from which to remove the Data Lake Store account.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568292 = path.getOrDefault("resourceGroupName")
  valid_568292 = validateParameter(valid_568292, JString, required = true,
                                 default = nil)
  if valid_568292 != nil:
    section.add "resourceGroupName", valid_568292
  var valid_568293 = path.getOrDefault("subscriptionId")
  valid_568293 = validateParameter(valid_568293, JString, required = true,
                                 default = nil)
  if valid_568293 != nil:
    section.add "subscriptionId", valid_568293
  var valid_568294 = path.getOrDefault("dataLakeStoreAccountName")
  valid_568294 = validateParameter(valid_568294, JString, required = true,
                                 default = nil)
  if valid_568294 != nil:
    section.add "dataLakeStoreAccountName", valid_568294
  var valid_568295 = path.getOrDefault("accountName")
  valid_568295 = validateParameter(valid_568295, JString, required = true,
                                 default = nil)
  if valid_568295 != nil:
    section.add "accountName", valid_568295
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568296 = query.getOrDefault("api-version")
  valid_568296 = validateParameter(valid_568296, JString, required = true,
                                 default = nil)
  if valid_568296 != nil:
    section.add "api-version", valid_568296
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568297: Call_AccountDeleteDataLakeStoreAccount_568289;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates the Data Lake Analytics account specified to remove the specified Data Lake Store account.
  ## 
  let valid = call_568297.validator(path, query, header, formData, body)
  let scheme = call_568297.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568297.url(scheme.get, call_568297.host, call_568297.base,
                         call_568297.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568297, url, valid)

proc call*(call_568298: Call_AccountDeleteDataLakeStoreAccount_568289;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          dataLakeStoreAccountName: string; accountName: string): Recallable =
  ## accountDeleteDataLakeStoreAccount
  ## Updates the Data Lake Analytics account specified to remove the specified Data Lake Store account.
  ##   resourceGroupName: string (required)
  ##                    : The name of the Azure resource group that contains the Data Lake Analytics account.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Get subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   dataLakeStoreAccountName: string (required)
  ##                           : The name of the Data Lake Store account to remove
  ##   accountName: string (required)
  ##              : The name of the Data Lake Analytics account from which to remove the Data Lake Store account.
  var path_568299 = newJObject()
  var query_568300 = newJObject()
  add(path_568299, "resourceGroupName", newJString(resourceGroupName))
  add(query_568300, "api-version", newJString(apiVersion))
  add(path_568299, "subscriptionId", newJString(subscriptionId))
  add(path_568299, "dataLakeStoreAccountName",
      newJString(dataLakeStoreAccountName))
  add(path_568299, "accountName", newJString(accountName))
  result = call_568298.call(path_568299, query_568300, nil, nil, nil)

var accountDeleteDataLakeStoreAccount* = Call_AccountDeleteDataLakeStoreAccount_568289(
    name: "accountDeleteDataLakeStoreAccount", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataLakeAnalytics/accounts/{accountName}/DataLakeStoreAccounts/{dataLakeStoreAccountName}",
    validator: validate_AccountDeleteDataLakeStoreAccount_568290, base: "",
    url: url_AccountDeleteDataLakeStoreAccount_568291, schemes: {Scheme.Https})
type
  Call_AccountListStorageAccounts_568301 = ref object of OpenApiRestCall_567641
proc url_AccountListStorageAccounts_568303(protocol: Scheme; host: string;
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

proc validate_AccountListStorageAccounts_568302(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the first page of Azure Storage accounts, if any, linked to the specified Data Lake Analytics account. The response includes a link to the next page, if any.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the Azure resource group that contains the Data Lake Analytics account.
  ##   subscriptionId: JString (required)
  ##                 : Get subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   accountName: JString (required)
  ##              : The name of the Data Lake Analytics account for which to list Azure Storage accounts.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568304 = path.getOrDefault("resourceGroupName")
  valid_568304 = validateParameter(valid_568304, JString, required = true,
                                 default = nil)
  if valid_568304 != nil:
    section.add "resourceGroupName", valid_568304
  var valid_568305 = path.getOrDefault("subscriptionId")
  valid_568305 = validateParameter(valid_568305, JString, required = true,
                                 default = nil)
  if valid_568305 != nil:
    section.add "subscriptionId", valid_568305
  var valid_568306 = path.getOrDefault("accountName")
  valid_568306 = validateParameter(valid_568306, JString, required = true,
                                 default = nil)
  if valid_568306 != nil:
    section.add "accountName", valid_568306
  result.add "path", section
  ## parameters in `query` object:
  ##   $orderby: JString
  ##           : OrderBy clause. One or more comma-separated expressions with an optional "asc" (the default) or "desc" depending on the order you'd like the values sorted, e.g. Categories?$orderby=CategoryName desc. Optional.
  ##   $expand: JString
  ##          : OData expansion. Expand related resources in line with the retrieved resources, e.g. Categories/$expand=Products would expand Product data in line with each Category entry. Optional.
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   $top: JInt
  ##       : The number of items to return. Optional.
  ##   $select: JString
  ##          : OData Select statement. Limits the properties on each entry to just those requested, e.g. Categories?$select=CategoryName,Description. Optional.
  ##   $skip: JInt
  ##        : The number of items to skip over before returning elements. Optional.
  ##   $count: JBool
  ##         : The Boolean value of true or false to request a count of the matching resources included with the resources in the response, e.g. Categories?$count=true. Optional.
  ##   $search: JString
  ##          : A free form search. A free-text search expression to match for whether a particular entry should be included in the feed, e.g. Categories?$search=blue OR green. Optional.
  ##   $format: JString
  ##          : The desired return format. Return the response in particular format without access to request headers for standard content-type negotiation (e.g Orders?$format=json). Optional.
  ##   $filter: JString
  ##          : The OData filter. Optional.
  section = newJObject()
  var valid_568307 = query.getOrDefault("$orderby")
  valid_568307 = validateParameter(valid_568307, JString, required = false,
                                 default = nil)
  if valid_568307 != nil:
    section.add "$orderby", valid_568307
  var valid_568308 = query.getOrDefault("$expand")
  valid_568308 = validateParameter(valid_568308, JString, required = false,
                                 default = nil)
  if valid_568308 != nil:
    section.add "$expand", valid_568308
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568309 = query.getOrDefault("api-version")
  valid_568309 = validateParameter(valid_568309, JString, required = true,
                                 default = nil)
  if valid_568309 != nil:
    section.add "api-version", valid_568309
  var valid_568310 = query.getOrDefault("$top")
  valid_568310 = validateParameter(valid_568310, JInt, required = false, default = nil)
  if valid_568310 != nil:
    section.add "$top", valid_568310
  var valid_568311 = query.getOrDefault("$select")
  valid_568311 = validateParameter(valid_568311, JString, required = false,
                                 default = nil)
  if valid_568311 != nil:
    section.add "$select", valid_568311
  var valid_568312 = query.getOrDefault("$skip")
  valid_568312 = validateParameter(valid_568312, JInt, required = false, default = nil)
  if valid_568312 != nil:
    section.add "$skip", valid_568312
  var valid_568313 = query.getOrDefault("$count")
  valid_568313 = validateParameter(valid_568313, JBool, required = false, default = nil)
  if valid_568313 != nil:
    section.add "$count", valid_568313
  var valid_568314 = query.getOrDefault("$search")
  valid_568314 = validateParameter(valid_568314, JString, required = false,
                                 default = nil)
  if valid_568314 != nil:
    section.add "$search", valid_568314
  var valid_568315 = query.getOrDefault("$format")
  valid_568315 = validateParameter(valid_568315, JString, required = false,
                                 default = nil)
  if valid_568315 != nil:
    section.add "$format", valid_568315
  var valid_568316 = query.getOrDefault("$filter")
  valid_568316 = validateParameter(valid_568316, JString, required = false,
                                 default = nil)
  if valid_568316 != nil:
    section.add "$filter", valid_568316
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568317: Call_AccountListStorageAccounts_568301; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the first page of Azure Storage accounts, if any, linked to the specified Data Lake Analytics account. The response includes a link to the next page, if any.
  ## 
  let valid = call_568317.validator(path, query, header, formData, body)
  let scheme = call_568317.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568317.url(scheme.get, call_568317.host, call_568317.base,
                         call_568317.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568317, url, valid)

proc call*(call_568318: Call_AccountListStorageAccounts_568301;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          accountName: string; Orderby: string = ""; Expand: string = ""; Top: int = 0;
          Select: string = ""; Skip: int = 0; Count: bool = false; Search: string = "";
          Format: string = ""; Filter: string = ""): Recallable =
  ## accountListStorageAccounts
  ## Gets the first page of Azure Storage accounts, if any, linked to the specified Data Lake Analytics account. The response includes a link to the next page, if any.
  ##   Orderby: string
  ##          : OrderBy clause. One or more comma-separated expressions with an optional "asc" (the default) or "desc" depending on the order you'd like the values sorted, e.g. Categories?$orderby=CategoryName desc. Optional.
  ##   resourceGroupName: string (required)
  ##                    : The name of the Azure resource group that contains the Data Lake Analytics account.
  ##   Expand: string
  ##         : OData expansion. Expand related resources in line with the retrieved resources, e.g. Categories/$expand=Products would expand Product data in line with each Category entry. Optional.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Get subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   Top: int
  ##      : The number of items to return. Optional.
  ##   Select: string
  ##         : OData Select statement. Limits the properties on each entry to just those requested, e.g. Categories?$select=CategoryName,Description. Optional.
  ##   Skip: int
  ##       : The number of items to skip over before returning elements. Optional.
  ##   Count: bool
  ##        : The Boolean value of true or false to request a count of the matching resources included with the resources in the response, e.g. Categories?$count=true. Optional.
  ##   Search: string
  ##         : A free form search. A free-text search expression to match for whether a particular entry should be included in the feed, e.g. Categories?$search=blue OR green. Optional.
  ##   Format: string
  ##         : The desired return format. Return the response in particular format without access to request headers for standard content-type negotiation (e.g Orders?$format=json). Optional.
  ##   accountName: string (required)
  ##              : The name of the Data Lake Analytics account for which to list Azure Storage accounts.
  ##   Filter: string
  ##         : The OData filter. Optional.
  var path_568319 = newJObject()
  var query_568320 = newJObject()
  add(query_568320, "$orderby", newJString(Orderby))
  add(path_568319, "resourceGroupName", newJString(resourceGroupName))
  add(query_568320, "$expand", newJString(Expand))
  add(query_568320, "api-version", newJString(apiVersion))
  add(path_568319, "subscriptionId", newJString(subscriptionId))
  add(query_568320, "$top", newJInt(Top))
  add(query_568320, "$select", newJString(Select))
  add(query_568320, "$skip", newJInt(Skip))
  add(query_568320, "$count", newJBool(Count))
  add(query_568320, "$search", newJString(Search))
  add(query_568320, "$format", newJString(Format))
  add(path_568319, "accountName", newJString(accountName))
  add(query_568320, "$filter", newJString(Filter))
  result = call_568318.call(path_568319, query_568320, nil, nil, nil)

var accountListStorageAccounts* = Call_AccountListStorageAccounts_568301(
    name: "accountListStorageAccounts", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataLakeAnalytics/accounts/{accountName}/StorageAccounts/",
    validator: validate_AccountListStorageAccounts_568302, base: "",
    url: url_AccountListStorageAccounts_568303, schemes: {Scheme.Https})
type
  Call_AccountAddStorageAccount_568333 = ref object of OpenApiRestCall_567641
proc url_AccountAddStorageAccount_568335(protocol: Scheme; host: string;
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

proc validate_AccountAddStorageAccount_568334(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates the specified Data Lake Analytics account to add an Azure Storage account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the Azure resource group that contains the Data Lake Analytics account.
  ##   storageAccountName: JString (required)
  ##                     : The name of the Azure Storage account to add
  ##   subscriptionId: JString (required)
  ##                 : Get subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   accountName: JString (required)
  ##              : The name of the Data Lake Analytics account to which to add the Azure Storage account.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568336 = path.getOrDefault("resourceGroupName")
  valid_568336 = validateParameter(valid_568336, JString, required = true,
                                 default = nil)
  if valid_568336 != nil:
    section.add "resourceGroupName", valid_568336
  var valid_568337 = path.getOrDefault("storageAccountName")
  valid_568337 = validateParameter(valid_568337, JString, required = true,
                                 default = nil)
  if valid_568337 != nil:
    section.add "storageAccountName", valid_568337
  var valid_568338 = path.getOrDefault("subscriptionId")
  valid_568338 = validateParameter(valid_568338, JString, required = true,
                                 default = nil)
  if valid_568338 != nil:
    section.add "subscriptionId", valid_568338
  var valid_568339 = path.getOrDefault("accountName")
  valid_568339 = validateParameter(valid_568339, JString, required = true,
                                 default = nil)
  if valid_568339 != nil:
    section.add "accountName", valid_568339
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568340 = query.getOrDefault("api-version")
  valid_568340 = validateParameter(valid_568340, JString, required = true,
                                 default = nil)
  if valid_568340 != nil:
    section.add "api-version", valid_568340
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

proc call*(call_568342: Call_AccountAddStorageAccount_568333; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the specified Data Lake Analytics account to add an Azure Storage account.
  ## 
  let valid = call_568342.validator(path, query, header, formData, body)
  let scheme = call_568342.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568342.url(scheme.get, call_568342.host, call_568342.base,
                         call_568342.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568342, url, valid)

proc call*(call_568343: Call_AccountAddStorageAccount_568333;
          resourceGroupName: string; apiVersion: string; storageAccountName: string;
          subscriptionId: string; parameters: JsonNode; accountName: string): Recallable =
  ## accountAddStorageAccount
  ## Updates the specified Data Lake Analytics account to add an Azure Storage account.
  ##   resourceGroupName: string (required)
  ##                    : The name of the Azure resource group that contains the Data Lake Analytics account.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   storageAccountName: string (required)
  ##                     : The name of the Azure Storage account to add
  ##   subscriptionId: string (required)
  ##                 : Get subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   parameters: JObject (required)
  ##             : The parameters containing the access key and optional suffix for the Azure Storage Account.
  ##   accountName: string (required)
  ##              : The name of the Data Lake Analytics account to which to add the Azure Storage account.
  var path_568344 = newJObject()
  var query_568345 = newJObject()
  var body_568346 = newJObject()
  add(path_568344, "resourceGroupName", newJString(resourceGroupName))
  add(query_568345, "api-version", newJString(apiVersion))
  add(path_568344, "storageAccountName", newJString(storageAccountName))
  add(path_568344, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_568346 = parameters
  add(path_568344, "accountName", newJString(accountName))
  result = call_568343.call(path_568344, query_568345, nil, nil, body_568346)

var accountAddStorageAccount* = Call_AccountAddStorageAccount_568333(
    name: "accountAddStorageAccount", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataLakeAnalytics/accounts/{accountName}/StorageAccounts/{storageAccountName}",
    validator: validate_AccountAddStorageAccount_568334, base: "",
    url: url_AccountAddStorageAccount_568335, schemes: {Scheme.Https})
type
  Call_AccountGetStorageAccount_568321 = ref object of OpenApiRestCall_567641
proc url_AccountGetStorageAccount_568323(protocol: Scheme; host: string;
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

proc validate_AccountGetStorageAccount_568322(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the specified Azure Storage account linked to the given Data Lake Analytics account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the Azure resource group that contains the Data Lake Analytics account.
  ##   storageAccountName: JString (required)
  ##                     : The name of the Azure Storage account for which to retrieve the details.
  ##   subscriptionId: JString (required)
  ##                 : Get subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   accountName: JString (required)
  ##              : The name of the Data Lake Analytics account from which to retrieve Azure storage account details.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568324 = path.getOrDefault("resourceGroupName")
  valid_568324 = validateParameter(valid_568324, JString, required = true,
                                 default = nil)
  if valid_568324 != nil:
    section.add "resourceGroupName", valid_568324
  var valid_568325 = path.getOrDefault("storageAccountName")
  valid_568325 = validateParameter(valid_568325, JString, required = true,
                                 default = nil)
  if valid_568325 != nil:
    section.add "storageAccountName", valid_568325
  var valid_568326 = path.getOrDefault("subscriptionId")
  valid_568326 = validateParameter(valid_568326, JString, required = true,
                                 default = nil)
  if valid_568326 != nil:
    section.add "subscriptionId", valid_568326
  var valid_568327 = path.getOrDefault("accountName")
  valid_568327 = validateParameter(valid_568327, JString, required = true,
                                 default = nil)
  if valid_568327 != nil:
    section.add "accountName", valid_568327
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568328 = query.getOrDefault("api-version")
  valid_568328 = validateParameter(valid_568328, JString, required = true,
                                 default = nil)
  if valid_568328 != nil:
    section.add "api-version", valid_568328
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568329: Call_AccountGetStorageAccount_568321; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the specified Azure Storage account linked to the given Data Lake Analytics account.
  ## 
  let valid = call_568329.validator(path, query, header, formData, body)
  let scheme = call_568329.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568329.url(scheme.get, call_568329.host, call_568329.base,
                         call_568329.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568329, url, valid)

proc call*(call_568330: Call_AccountGetStorageAccount_568321;
          resourceGroupName: string; apiVersion: string; storageAccountName: string;
          subscriptionId: string; accountName: string): Recallable =
  ## accountGetStorageAccount
  ## Gets the specified Azure Storage account linked to the given Data Lake Analytics account.
  ##   resourceGroupName: string (required)
  ##                    : The name of the Azure resource group that contains the Data Lake Analytics account.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   storageAccountName: string (required)
  ##                     : The name of the Azure Storage account for which to retrieve the details.
  ##   subscriptionId: string (required)
  ##                 : Get subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   accountName: string (required)
  ##              : The name of the Data Lake Analytics account from which to retrieve Azure storage account details.
  var path_568331 = newJObject()
  var query_568332 = newJObject()
  add(path_568331, "resourceGroupName", newJString(resourceGroupName))
  add(query_568332, "api-version", newJString(apiVersion))
  add(path_568331, "storageAccountName", newJString(storageAccountName))
  add(path_568331, "subscriptionId", newJString(subscriptionId))
  add(path_568331, "accountName", newJString(accountName))
  result = call_568330.call(path_568331, query_568332, nil, nil, nil)

var accountGetStorageAccount* = Call_AccountGetStorageAccount_568321(
    name: "accountGetStorageAccount", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataLakeAnalytics/accounts/{accountName}/StorageAccounts/{storageAccountName}",
    validator: validate_AccountGetStorageAccount_568322, base: "",
    url: url_AccountGetStorageAccount_568323, schemes: {Scheme.Https})
type
  Call_AccountUpdateStorageAccount_568359 = ref object of OpenApiRestCall_567641
proc url_AccountUpdateStorageAccount_568361(protocol: Scheme; host: string;
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

proc validate_AccountUpdateStorageAccount_568360(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates the Data Lake Analytics account to replace Azure Storage blob account details, such as the access key and/or suffix.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the Azure resource group that contains the Data Lake Analytics account.
  ##   storageAccountName: JString (required)
  ##                     : The Azure Storage account to modify
  ##   subscriptionId: JString (required)
  ##                 : Get subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   accountName: JString (required)
  ##              : The name of the Data Lake Analytics account to modify storage accounts in
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568362 = path.getOrDefault("resourceGroupName")
  valid_568362 = validateParameter(valid_568362, JString, required = true,
                                 default = nil)
  if valid_568362 != nil:
    section.add "resourceGroupName", valid_568362
  var valid_568363 = path.getOrDefault("storageAccountName")
  valid_568363 = validateParameter(valid_568363, JString, required = true,
                                 default = nil)
  if valid_568363 != nil:
    section.add "storageAccountName", valid_568363
  var valid_568364 = path.getOrDefault("subscriptionId")
  valid_568364 = validateParameter(valid_568364, JString, required = true,
                                 default = nil)
  if valid_568364 != nil:
    section.add "subscriptionId", valid_568364
  var valid_568365 = path.getOrDefault("accountName")
  valid_568365 = validateParameter(valid_568365, JString, required = true,
                                 default = nil)
  if valid_568365 != nil:
    section.add "accountName", valid_568365
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568366 = query.getOrDefault("api-version")
  valid_568366 = validateParameter(valid_568366, JString, required = true,
                                 default = nil)
  if valid_568366 != nil:
    section.add "api-version", valid_568366
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

proc call*(call_568368: Call_AccountUpdateStorageAccount_568359; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the Data Lake Analytics account to replace Azure Storage blob account details, such as the access key and/or suffix.
  ## 
  let valid = call_568368.validator(path, query, header, formData, body)
  let scheme = call_568368.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568368.url(scheme.get, call_568368.host, call_568368.base,
                         call_568368.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568368, url, valid)

proc call*(call_568369: Call_AccountUpdateStorageAccount_568359;
          resourceGroupName: string; apiVersion: string; storageAccountName: string;
          subscriptionId: string; parameters: JsonNode; accountName: string): Recallable =
  ## accountUpdateStorageAccount
  ## Updates the Data Lake Analytics account to replace Azure Storage blob account details, such as the access key and/or suffix.
  ##   resourceGroupName: string (required)
  ##                    : The name of the Azure resource group that contains the Data Lake Analytics account.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   storageAccountName: string (required)
  ##                     : The Azure Storage account to modify
  ##   subscriptionId: string (required)
  ##                 : Get subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   parameters: JObject (required)
  ##             : The parameters containing the access key and suffix to update the storage account with.
  ##   accountName: string (required)
  ##              : The name of the Data Lake Analytics account to modify storage accounts in
  var path_568370 = newJObject()
  var query_568371 = newJObject()
  var body_568372 = newJObject()
  add(path_568370, "resourceGroupName", newJString(resourceGroupName))
  add(query_568371, "api-version", newJString(apiVersion))
  add(path_568370, "storageAccountName", newJString(storageAccountName))
  add(path_568370, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_568372 = parameters
  add(path_568370, "accountName", newJString(accountName))
  result = call_568369.call(path_568370, query_568371, nil, nil, body_568372)

var accountUpdateStorageAccount* = Call_AccountUpdateStorageAccount_568359(
    name: "accountUpdateStorageAccount", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataLakeAnalytics/accounts/{accountName}/StorageAccounts/{storageAccountName}",
    validator: validate_AccountUpdateStorageAccount_568360, base: "",
    url: url_AccountUpdateStorageAccount_568361, schemes: {Scheme.Https})
type
  Call_AccountDeleteStorageAccount_568347 = ref object of OpenApiRestCall_567641
proc url_AccountDeleteStorageAccount_568349(protocol: Scheme; host: string;
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

proc validate_AccountDeleteStorageAccount_568348(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates the specified Data Lake Analytics account to remove an Azure Storage account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the Azure resource group that contains the Data Lake Analytics account.
  ##   storageAccountName: JString (required)
  ##                     : The name of the Azure Storage account to remove
  ##   subscriptionId: JString (required)
  ##                 : Get subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   accountName: JString (required)
  ##              : The name of the Data Lake Analytics account from which to remove the Azure Storage account.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568350 = path.getOrDefault("resourceGroupName")
  valid_568350 = validateParameter(valid_568350, JString, required = true,
                                 default = nil)
  if valid_568350 != nil:
    section.add "resourceGroupName", valid_568350
  var valid_568351 = path.getOrDefault("storageAccountName")
  valid_568351 = validateParameter(valid_568351, JString, required = true,
                                 default = nil)
  if valid_568351 != nil:
    section.add "storageAccountName", valid_568351
  var valid_568352 = path.getOrDefault("subscriptionId")
  valid_568352 = validateParameter(valid_568352, JString, required = true,
                                 default = nil)
  if valid_568352 != nil:
    section.add "subscriptionId", valid_568352
  var valid_568353 = path.getOrDefault("accountName")
  valid_568353 = validateParameter(valid_568353, JString, required = true,
                                 default = nil)
  if valid_568353 != nil:
    section.add "accountName", valid_568353
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568354 = query.getOrDefault("api-version")
  valid_568354 = validateParameter(valid_568354, JString, required = true,
                                 default = nil)
  if valid_568354 != nil:
    section.add "api-version", valid_568354
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568355: Call_AccountDeleteStorageAccount_568347; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the specified Data Lake Analytics account to remove an Azure Storage account.
  ## 
  let valid = call_568355.validator(path, query, header, formData, body)
  let scheme = call_568355.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568355.url(scheme.get, call_568355.host, call_568355.base,
                         call_568355.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568355, url, valid)

proc call*(call_568356: Call_AccountDeleteStorageAccount_568347;
          resourceGroupName: string; apiVersion: string; storageAccountName: string;
          subscriptionId: string; accountName: string): Recallable =
  ## accountDeleteStorageAccount
  ## Updates the specified Data Lake Analytics account to remove an Azure Storage account.
  ##   resourceGroupName: string (required)
  ##                    : The name of the Azure resource group that contains the Data Lake Analytics account.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   storageAccountName: string (required)
  ##                     : The name of the Azure Storage account to remove
  ##   subscriptionId: string (required)
  ##                 : Get subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   accountName: string (required)
  ##              : The name of the Data Lake Analytics account from which to remove the Azure Storage account.
  var path_568357 = newJObject()
  var query_568358 = newJObject()
  add(path_568357, "resourceGroupName", newJString(resourceGroupName))
  add(query_568358, "api-version", newJString(apiVersion))
  add(path_568357, "storageAccountName", newJString(storageAccountName))
  add(path_568357, "subscriptionId", newJString(subscriptionId))
  add(path_568357, "accountName", newJString(accountName))
  result = call_568356.call(path_568357, query_568358, nil, nil, nil)

var accountDeleteStorageAccount* = Call_AccountDeleteStorageAccount_568347(
    name: "accountDeleteStorageAccount", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataLakeAnalytics/accounts/{accountName}/StorageAccounts/{storageAccountName}",
    validator: validate_AccountDeleteStorageAccount_568348, base: "",
    url: url_AccountDeleteStorageAccount_568349, schemes: {Scheme.Https})
type
  Call_AccountListStorageContainers_568373 = ref object of OpenApiRestCall_567641
proc url_AccountListStorageContainers_568375(protocol: Scheme; host: string;
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

proc validate_AccountListStorageContainers_568374(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists the Azure Storage containers, if any, associated with the specified Data Lake Analytics and Azure Storage account combination. The response includes a link to the next page of results, if any.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the Azure resource group that contains the Data Lake Analytics account.
  ##   storageAccountName: JString (required)
  ##                     : The name of the Azure storage account from which to list blob containers.
  ##   subscriptionId: JString (required)
  ##                 : Get subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   accountName: JString (required)
  ##              : The name of the Data Lake Analytics account for which to list Azure Storage blob containers.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568376 = path.getOrDefault("resourceGroupName")
  valid_568376 = validateParameter(valid_568376, JString, required = true,
                                 default = nil)
  if valid_568376 != nil:
    section.add "resourceGroupName", valid_568376
  var valid_568377 = path.getOrDefault("storageAccountName")
  valid_568377 = validateParameter(valid_568377, JString, required = true,
                                 default = nil)
  if valid_568377 != nil:
    section.add "storageAccountName", valid_568377
  var valid_568378 = path.getOrDefault("subscriptionId")
  valid_568378 = validateParameter(valid_568378, JString, required = true,
                                 default = nil)
  if valid_568378 != nil:
    section.add "subscriptionId", valid_568378
  var valid_568379 = path.getOrDefault("accountName")
  valid_568379 = validateParameter(valid_568379, JString, required = true,
                                 default = nil)
  if valid_568379 != nil:
    section.add "accountName", valid_568379
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568380 = query.getOrDefault("api-version")
  valid_568380 = validateParameter(valid_568380, JString, required = true,
                                 default = nil)
  if valid_568380 != nil:
    section.add "api-version", valid_568380
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568381: Call_AccountListStorageContainers_568373; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the Azure Storage containers, if any, associated with the specified Data Lake Analytics and Azure Storage account combination. The response includes a link to the next page of results, if any.
  ## 
  let valid = call_568381.validator(path, query, header, formData, body)
  let scheme = call_568381.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568381.url(scheme.get, call_568381.host, call_568381.base,
                         call_568381.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568381, url, valid)

proc call*(call_568382: Call_AccountListStorageContainers_568373;
          resourceGroupName: string; apiVersion: string; storageAccountName: string;
          subscriptionId: string; accountName: string): Recallable =
  ## accountListStorageContainers
  ## Lists the Azure Storage containers, if any, associated with the specified Data Lake Analytics and Azure Storage account combination. The response includes a link to the next page of results, if any.
  ##   resourceGroupName: string (required)
  ##                    : The name of the Azure resource group that contains the Data Lake Analytics account.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   storageAccountName: string (required)
  ##                     : The name of the Azure storage account from which to list blob containers.
  ##   subscriptionId: string (required)
  ##                 : Get subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   accountName: string (required)
  ##              : The name of the Data Lake Analytics account for which to list Azure Storage blob containers.
  var path_568383 = newJObject()
  var query_568384 = newJObject()
  add(path_568383, "resourceGroupName", newJString(resourceGroupName))
  add(query_568384, "api-version", newJString(apiVersion))
  add(path_568383, "storageAccountName", newJString(storageAccountName))
  add(path_568383, "subscriptionId", newJString(subscriptionId))
  add(path_568383, "accountName", newJString(accountName))
  result = call_568382.call(path_568383, query_568384, nil, nil, nil)

var accountListStorageContainers* = Call_AccountListStorageContainers_568373(
    name: "accountListStorageContainers", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataLakeAnalytics/accounts/{accountName}/StorageAccounts/{storageAccountName}/Containers",
    validator: validate_AccountListStorageContainers_568374, base: "",
    url: url_AccountListStorageContainers_568375, schemes: {Scheme.Https})
type
  Call_AccountGetStorageContainer_568385 = ref object of OpenApiRestCall_567641
proc url_AccountGetStorageContainer_568387(protocol: Scheme; host: string;
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

proc validate_AccountGetStorageContainer_568386(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the specified Azure Storage container associated with the given Data Lake Analytics and Azure Storage accounts.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the Azure resource group that contains the Data Lake Analytics account.
  ##   containerName: JString (required)
  ##                : The name of the Azure storage container to retrieve
  ##   storageAccountName: JString (required)
  ##                     : The name of the Azure storage account from which to retrieve the blob container.
  ##   subscriptionId: JString (required)
  ##                 : Get subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   accountName: JString (required)
  ##              : The name of the Data Lake Analytics account for which to retrieve blob container.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568388 = path.getOrDefault("resourceGroupName")
  valid_568388 = validateParameter(valid_568388, JString, required = true,
                                 default = nil)
  if valid_568388 != nil:
    section.add "resourceGroupName", valid_568388
  var valid_568389 = path.getOrDefault("containerName")
  valid_568389 = validateParameter(valid_568389, JString, required = true,
                                 default = nil)
  if valid_568389 != nil:
    section.add "containerName", valid_568389
  var valid_568390 = path.getOrDefault("storageAccountName")
  valid_568390 = validateParameter(valid_568390, JString, required = true,
                                 default = nil)
  if valid_568390 != nil:
    section.add "storageAccountName", valid_568390
  var valid_568391 = path.getOrDefault("subscriptionId")
  valid_568391 = validateParameter(valid_568391, JString, required = true,
                                 default = nil)
  if valid_568391 != nil:
    section.add "subscriptionId", valid_568391
  var valid_568392 = path.getOrDefault("accountName")
  valid_568392 = validateParameter(valid_568392, JString, required = true,
                                 default = nil)
  if valid_568392 != nil:
    section.add "accountName", valid_568392
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568393 = query.getOrDefault("api-version")
  valid_568393 = validateParameter(valid_568393, JString, required = true,
                                 default = nil)
  if valid_568393 != nil:
    section.add "api-version", valid_568393
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568394: Call_AccountGetStorageContainer_568385; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the specified Azure Storage container associated with the given Data Lake Analytics and Azure Storage accounts.
  ## 
  let valid = call_568394.validator(path, query, header, formData, body)
  let scheme = call_568394.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568394.url(scheme.get, call_568394.host, call_568394.base,
                         call_568394.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568394, url, valid)

proc call*(call_568395: Call_AccountGetStorageContainer_568385;
          resourceGroupName: string; apiVersion: string; containerName: string;
          storageAccountName: string; subscriptionId: string; accountName: string): Recallable =
  ## accountGetStorageContainer
  ## Gets the specified Azure Storage container associated with the given Data Lake Analytics and Azure Storage accounts.
  ##   resourceGroupName: string (required)
  ##                    : The name of the Azure resource group that contains the Data Lake Analytics account.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   containerName: string (required)
  ##                : The name of the Azure storage container to retrieve
  ##   storageAccountName: string (required)
  ##                     : The name of the Azure storage account from which to retrieve the blob container.
  ##   subscriptionId: string (required)
  ##                 : Get subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   accountName: string (required)
  ##              : The name of the Data Lake Analytics account for which to retrieve blob container.
  var path_568396 = newJObject()
  var query_568397 = newJObject()
  add(path_568396, "resourceGroupName", newJString(resourceGroupName))
  add(query_568397, "api-version", newJString(apiVersion))
  add(path_568396, "containerName", newJString(containerName))
  add(path_568396, "storageAccountName", newJString(storageAccountName))
  add(path_568396, "subscriptionId", newJString(subscriptionId))
  add(path_568396, "accountName", newJString(accountName))
  result = call_568395.call(path_568396, query_568397, nil, nil, nil)

var accountGetStorageContainer* = Call_AccountGetStorageContainer_568385(
    name: "accountGetStorageContainer", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataLakeAnalytics/accounts/{accountName}/StorageAccounts/{storageAccountName}/Containers/{containerName}",
    validator: validate_AccountGetStorageContainer_568386, base: "",
    url: url_AccountGetStorageContainer_568387, schemes: {Scheme.Https})
type
  Call_AccountListSasTokens_568398 = ref object of OpenApiRestCall_567641
proc url_AccountListSasTokens_568400(protocol: Scheme; host: string; base: string;
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

proc validate_AccountListSasTokens_568399(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the SAS token associated with the specified Data Lake Analytics and Azure Storage account and container combination.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the Azure resource group that contains the Data Lake Analytics account.
  ##   containerName: JString (required)
  ##                : The name of the Azure storage container for which the SAS token is being requested.
  ##   storageAccountName: JString (required)
  ##                     : The name of the Azure storage account for which the SAS token is being requested.
  ##   subscriptionId: JString (required)
  ##                 : Get subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   accountName: JString (required)
  ##              : The name of the Data Lake Analytics account from which an Azure Storage account's SAS token is being requested.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568401 = path.getOrDefault("resourceGroupName")
  valid_568401 = validateParameter(valid_568401, JString, required = true,
                                 default = nil)
  if valid_568401 != nil:
    section.add "resourceGroupName", valid_568401
  var valid_568402 = path.getOrDefault("containerName")
  valid_568402 = validateParameter(valid_568402, JString, required = true,
                                 default = nil)
  if valid_568402 != nil:
    section.add "containerName", valid_568402
  var valid_568403 = path.getOrDefault("storageAccountName")
  valid_568403 = validateParameter(valid_568403, JString, required = true,
                                 default = nil)
  if valid_568403 != nil:
    section.add "storageAccountName", valid_568403
  var valid_568404 = path.getOrDefault("subscriptionId")
  valid_568404 = validateParameter(valid_568404, JString, required = true,
                                 default = nil)
  if valid_568404 != nil:
    section.add "subscriptionId", valid_568404
  var valid_568405 = path.getOrDefault("accountName")
  valid_568405 = validateParameter(valid_568405, JString, required = true,
                                 default = nil)
  if valid_568405 != nil:
    section.add "accountName", valid_568405
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568406 = query.getOrDefault("api-version")
  valid_568406 = validateParameter(valid_568406, JString, required = true,
                                 default = nil)
  if valid_568406 != nil:
    section.add "api-version", valid_568406
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568407: Call_AccountListSasTokens_568398; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the SAS token associated with the specified Data Lake Analytics and Azure Storage account and container combination.
  ## 
  let valid = call_568407.validator(path, query, header, formData, body)
  let scheme = call_568407.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568407.url(scheme.get, call_568407.host, call_568407.base,
                         call_568407.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568407, url, valid)

proc call*(call_568408: Call_AccountListSasTokens_568398;
          resourceGroupName: string; apiVersion: string; containerName: string;
          storageAccountName: string; subscriptionId: string; accountName: string): Recallable =
  ## accountListSasTokens
  ## Gets the SAS token associated with the specified Data Lake Analytics and Azure Storage account and container combination.
  ##   resourceGroupName: string (required)
  ##                    : The name of the Azure resource group that contains the Data Lake Analytics account.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   containerName: string (required)
  ##                : The name of the Azure storage container for which the SAS token is being requested.
  ##   storageAccountName: string (required)
  ##                     : The name of the Azure storage account for which the SAS token is being requested.
  ##   subscriptionId: string (required)
  ##                 : Get subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   accountName: string (required)
  ##              : The name of the Data Lake Analytics account from which an Azure Storage account's SAS token is being requested.
  var path_568409 = newJObject()
  var query_568410 = newJObject()
  add(path_568409, "resourceGroupName", newJString(resourceGroupName))
  add(query_568410, "api-version", newJString(apiVersion))
  add(path_568409, "containerName", newJString(containerName))
  add(path_568409, "storageAccountName", newJString(storageAccountName))
  add(path_568409, "subscriptionId", newJString(subscriptionId))
  add(path_568409, "accountName", newJString(accountName))
  result = call_568408.call(path_568409, query_568410, nil, nil, nil)

var accountListSasTokens* = Call_AccountListSasTokens_568398(
    name: "accountListSasTokens", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataLakeAnalytics/accounts/{accountName}/StorageAccounts/{storageAccountName}/Containers/{containerName}/listSasTokens",
    validator: validate_AccountListSasTokens_568399, base: "",
    url: url_AccountListSasTokens_568400, schemes: {Scheme.Https})
type
  Call_AccountCreate_568411 = ref object of OpenApiRestCall_567641
proc url_AccountCreate_568413(protocol: Scheme; host: string; base: string;
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

proc validate_AccountCreate_568412(path: JsonNode; query: JsonNode; header: JsonNode;
                                  formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates the specified Data Lake Analytics account. This supplies the user with computation services for Data Lake Analytics workloads
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the Azure resource group that contains the Data Lake Analytics account.the account will be associated with.
  ##   name: JString (required)
  ##       : The name of the Data Lake Analytics account to create.
  ##   subscriptionId: JString (required)
  ##                 : Get subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568414 = path.getOrDefault("resourceGroupName")
  valid_568414 = validateParameter(valid_568414, JString, required = true,
                                 default = nil)
  if valid_568414 != nil:
    section.add "resourceGroupName", valid_568414
  var valid_568415 = path.getOrDefault("name")
  valid_568415 = validateParameter(valid_568415, JString, required = true,
                                 default = nil)
  if valid_568415 != nil:
    section.add "name", valid_568415
  var valid_568416 = path.getOrDefault("subscriptionId")
  valid_568416 = validateParameter(valid_568416, JString, required = true,
                                 default = nil)
  if valid_568416 != nil:
    section.add "subscriptionId", valid_568416
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568417 = query.getOrDefault("api-version")
  valid_568417 = validateParameter(valid_568417, JString, required = true,
                                 default = nil)
  if valid_568417 != nil:
    section.add "api-version", valid_568417
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

proc call*(call_568419: Call_AccountCreate_568411; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates the specified Data Lake Analytics account. This supplies the user with computation services for Data Lake Analytics workloads
  ## 
  let valid = call_568419.validator(path, query, header, formData, body)
  let scheme = call_568419.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568419.url(scheme.get, call_568419.host, call_568419.base,
                         call_568419.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568419, url, valid)

proc call*(call_568420: Call_AccountCreate_568411; resourceGroupName: string;
          apiVersion: string; name: string; subscriptionId: string;
          parameters: JsonNode): Recallable =
  ## accountCreate
  ## Creates the specified Data Lake Analytics account. This supplies the user with computation services for Data Lake Analytics workloads
  ##   resourceGroupName: string (required)
  ##                    : The name of the Azure resource group that contains the Data Lake Analytics account.the account will be associated with.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   name: string (required)
  ##       : The name of the Data Lake Analytics account to create.
  ##   subscriptionId: string (required)
  ##                 : Get subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the create Data Lake Analytics account operation.
  var path_568421 = newJObject()
  var query_568422 = newJObject()
  var body_568423 = newJObject()
  add(path_568421, "resourceGroupName", newJString(resourceGroupName))
  add(query_568422, "api-version", newJString(apiVersion))
  add(path_568421, "name", newJString(name))
  add(path_568421, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_568423 = parameters
  result = call_568420.call(path_568421, query_568422, nil, nil, body_568423)

var accountCreate* = Call_AccountCreate_568411(name: "accountCreate",
    meth: HttpMethod.HttpPut, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataLakeAnalytics/accounts/{name}",
    validator: validate_AccountCreate_568412, base: "", url: url_AccountCreate_568413,
    schemes: {Scheme.Https})
type
  Call_AccountUpdate_568424 = ref object of OpenApiRestCall_567641
proc url_AccountUpdate_568426(protocol: Scheme; host: string; base: string;
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

proc validate_AccountUpdate_568425(path: JsonNode; query: JsonNode; header: JsonNode;
                                  formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates the Data Lake Analytics account object specified by the accountName with the contents of the account object.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the Azure resource group that contains the Data Lake Analytics account.
  ##   name: JString (required)
  ##       : The name of the Data Lake Analytics account to update.
  ##   subscriptionId: JString (required)
  ##                 : Get subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568427 = path.getOrDefault("resourceGroupName")
  valid_568427 = validateParameter(valid_568427, JString, required = true,
                                 default = nil)
  if valid_568427 != nil:
    section.add "resourceGroupName", valid_568427
  var valid_568428 = path.getOrDefault("name")
  valid_568428 = validateParameter(valid_568428, JString, required = true,
                                 default = nil)
  if valid_568428 != nil:
    section.add "name", valid_568428
  var valid_568429 = path.getOrDefault("subscriptionId")
  valid_568429 = validateParameter(valid_568429, JString, required = true,
                                 default = nil)
  if valid_568429 != nil:
    section.add "subscriptionId", valid_568429
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568430 = query.getOrDefault("api-version")
  valid_568430 = validateParameter(valid_568430, JString, required = true,
                                 default = nil)
  if valid_568430 != nil:
    section.add "api-version", valid_568430
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

proc call*(call_568432: Call_AccountUpdate_568424; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the Data Lake Analytics account object specified by the accountName with the contents of the account object.
  ## 
  let valid = call_568432.validator(path, query, header, formData, body)
  let scheme = call_568432.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568432.url(scheme.get, call_568432.host, call_568432.base,
                         call_568432.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568432, url, valid)

proc call*(call_568433: Call_AccountUpdate_568424; resourceGroupName: string;
          apiVersion: string; name: string; subscriptionId: string;
          parameters: JsonNode): Recallable =
  ## accountUpdate
  ## Updates the Data Lake Analytics account object specified by the accountName with the contents of the account object.
  ##   resourceGroupName: string (required)
  ##                    : The name of the Azure resource group that contains the Data Lake Analytics account.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   name: string (required)
  ##       : The name of the Data Lake Analytics account to update.
  ##   subscriptionId: string (required)
  ##                 : Get subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the update Data Lake Analytics account operation.
  var path_568434 = newJObject()
  var query_568435 = newJObject()
  var body_568436 = newJObject()
  add(path_568434, "resourceGroupName", newJString(resourceGroupName))
  add(query_568435, "api-version", newJString(apiVersion))
  add(path_568434, "name", newJString(name))
  add(path_568434, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_568436 = parameters
  result = call_568433.call(path_568434, query_568435, nil, nil, body_568436)

var accountUpdate* = Call_AccountUpdate_568424(name: "accountUpdate",
    meth: HttpMethod.HttpPatch, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataLakeAnalytics/accounts/{name}",
    validator: validate_AccountUpdate_568425, base: "", url: url_AccountUpdate_568426,
    schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)

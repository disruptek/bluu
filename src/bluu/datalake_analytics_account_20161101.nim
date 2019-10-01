
import
  json, options, hashes, uri, rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: DataLakeAnalyticsAccountManagementClient
## version: 2016-11-01
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

  OpenApiRestCall_567666 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_567666](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_567666): Option[Scheme] {.used.} =
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
  Call_OperationsList_567888 = ref object of OpenApiRestCall_567666
proc url_OperationsList_567890(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_OperationsList_567889(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Lists all of the available Data Lake Analytics REST API operations.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568049 = query.getOrDefault("api-version")
  valid_568049 = validateParameter(valid_568049, JString, required = true,
                                 default = nil)
  if valid_568049 != nil:
    section.add "api-version", valid_568049
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568072: Call_OperationsList_567888; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all of the available Data Lake Analytics REST API operations.
  ## 
  let valid = call_568072.validator(path, query, header, formData, body)
  let scheme = call_568072.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568072.url(scheme.get, call_568072.host, call_568072.base,
                         call_568072.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568072, url, valid)

proc call*(call_568143: Call_OperationsList_567888; apiVersion: string): Recallable =
  ## operationsList
  ## Lists all of the available Data Lake Analytics REST API operations.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  var query_568144 = newJObject()
  add(query_568144, "api-version", newJString(apiVersion))
  result = call_568143.call(nil, query_568144, nil, nil, nil)

var operationsList* = Call_OperationsList_567888(name: "operationsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com",
    route: "/providers/Microsoft.DataLakeAnalytics/operations",
    validator: validate_OperationsList_567889, base: "", url: url_OperationsList_567890,
    schemes: {Scheme.Https})
type
  Call_AccountsList_568184 = ref object of OpenApiRestCall_567666
proc url_AccountsList_568186(protocol: Scheme; host: string; base: string;
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

proc validate_AccountsList_568185(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_568202 = path.getOrDefault("subscriptionId")
  valid_568202 = validateParameter(valid_568202, JString, required = true,
                                 default = nil)
  if valid_568202 != nil:
    section.add "subscriptionId", valid_568202
  result.add "path", section
  ## parameters in `query` object:
  ##   $orderby: JString
  ##           : OrderBy clause. One or more comma-separated expressions with an optional "asc" (the default) or "desc" depending on the order you'd like the values sorted, e.g. Categories?$orderby=CategoryName desc. Optional.
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
  ##   $filter: JString
  ##          : OData filter. Optional.
  section = newJObject()
  var valid_568203 = query.getOrDefault("$orderby")
  valid_568203 = validateParameter(valid_568203, JString, required = false,
                                 default = nil)
  if valid_568203 != nil:
    section.add "$orderby", valid_568203
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568204 = query.getOrDefault("api-version")
  valid_568204 = validateParameter(valid_568204, JString, required = true,
                                 default = nil)
  if valid_568204 != nil:
    section.add "api-version", valid_568204
  var valid_568205 = query.getOrDefault("$top")
  valid_568205 = validateParameter(valid_568205, JInt, required = false, default = nil)
  if valid_568205 != nil:
    section.add "$top", valid_568205
  var valid_568206 = query.getOrDefault("$select")
  valid_568206 = validateParameter(valid_568206, JString, required = false,
                                 default = nil)
  if valid_568206 != nil:
    section.add "$select", valid_568206
  var valid_568207 = query.getOrDefault("$skip")
  valid_568207 = validateParameter(valid_568207, JInt, required = false, default = nil)
  if valid_568207 != nil:
    section.add "$skip", valid_568207
  var valid_568208 = query.getOrDefault("$count")
  valid_568208 = validateParameter(valid_568208, JBool, required = false, default = nil)
  if valid_568208 != nil:
    section.add "$count", valid_568208
  var valid_568209 = query.getOrDefault("$filter")
  valid_568209 = validateParameter(valid_568209, JString, required = false,
                                 default = nil)
  if valid_568209 != nil:
    section.add "$filter", valid_568209
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568210: Call_AccountsList_568184; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the first page of Data Lake Analytics accounts, if any, within the current subscription. This includes a link to the next page, if any.
  ## 
  let valid = call_568210.validator(path, query, header, formData, body)
  let scheme = call_568210.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568210.url(scheme.get, call_568210.host, call_568210.base,
                         call_568210.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568210, url, valid)

proc call*(call_568211: Call_AccountsList_568184; apiVersion: string;
          subscriptionId: string; Orderby: string = ""; Top: int = 0; Select: string = "";
          Skip: int = 0; Count: bool = false; Filter: string = ""): Recallable =
  ## accountsList
  ## Gets the first page of Data Lake Analytics accounts, if any, within the current subscription. This includes a link to the next page, if any.
  ##   Orderby: string
  ##          : OrderBy clause. One or more comma-separated expressions with an optional "asc" (the default) or "desc" depending on the order you'd like the values sorted, e.g. Categories?$orderby=CategoryName desc. Optional.
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
  ##   Filter: string
  ##         : OData filter. Optional.
  var path_568212 = newJObject()
  var query_568213 = newJObject()
  add(query_568213, "$orderby", newJString(Orderby))
  add(query_568213, "api-version", newJString(apiVersion))
  add(path_568212, "subscriptionId", newJString(subscriptionId))
  add(query_568213, "$top", newJInt(Top))
  add(query_568213, "$select", newJString(Select))
  add(query_568213, "$skip", newJInt(Skip))
  add(query_568213, "$count", newJBool(Count))
  add(query_568213, "$filter", newJString(Filter))
  result = call_568211.call(path_568212, query_568213, nil, nil, nil)

var accountsList* = Call_AccountsList_568184(name: "accountsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.DataLakeAnalytics/accounts",
    validator: validate_AccountsList_568185, base: "", url: url_AccountsList_568186,
    schemes: {Scheme.Https})
type
  Call_LocationsGetCapability_568214 = ref object of OpenApiRestCall_567666
proc url_LocationsGetCapability_568216(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "location" in path, "`location` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.DataLakeAnalytics/locations/"),
               (kind: VariableSegment, value: "location"),
               (kind: ConstantSegment, value: "/capability")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_LocationsGetCapability_568215(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets subscription-level properties and limits for Data Lake Analytics specified by resource location.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Get subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   location: JString (required)
  ##           : The resource location without whitespace.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_568217 = path.getOrDefault("subscriptionId")
  valid_568217 = validateParameter(valid_568217, JString, required = true,
                                 default = nil)
  if valid_568217 != nil:
    section.add "subscriptionId", valid_568217
  var valid_568218 = path.getOrDefault("location")
  valid_568218 = validateParameter(valid_568218, JString, required = true,
                                 default = nil)
  if valid_568218 != nil:
    section.add "location", valid_568218
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568219 = query.getOrDefault("api-version")
  valid_568219 = validateParameter(valid_568219, JString, required = true,
                                 default = nil)
  if valid_568219 != nil:
    section.add "api-version", valid_568219
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568220: Call_LocationsGetCapability_568214; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets subscription-level properties and limits for Data Lake Analytics specified by resource location.
  ## 
  let valid = call_568220.validator(path, query, header, formData, body)
  let scheme = call_568220.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568220.url(scheme.get, call_568220.host, call_568220.base,
                         call_568220.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568220, url, valid)

proc call*(call_568221: Call_LocationsGetCapability_568214; apiVersion: string;
          subscriptionId: string; location: string): Recallable =
  ## locationsGetCapability
  ## Gets subscription-level properties and limits for Data Lake Analytics specified by resource location.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Get subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   location: string (required)
  ##           : The resource location without whitespace.
  var path_568222 = newJObject()
  var query_568223 = newJObject()
  add(query_568223, "api-version", newJString(apiVersion))
  add(path_568222, "subscriptionId", newJString(subscriptionId))
  add(path_568222, "location", newJString(location))
  result = call_568221.call(path_568222, query_568223, nil, nil, nil)

var locationsGetCapability* = Call_LocationsGetCapability_568214(
    name: "locationsGetCapability", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.DataLakeAnalytics/locations/{location}/capability",
    validator: validate_LocationsGetCapability_568215, base: "",
    url: url_LocationsGetCapability_568216, schemes: {Scheme.Https})
type
  Call_AccountsCheckNameAvailability_568224 = ref object of OpenApiRestCall_567666
proc url_AccountsCheckNameAvailability_568226(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "location" in path, "`location` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.DataLakeAnalytics/locations/"),
               (kind: VariableSegment, value: "location"),
               (kind: ConstantSegment, value: "/checkNameAvailability")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AccountsCheckNameAvailability_568225(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Checks whether the specified account name is available or taken.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Get subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   location: JString (required)
  ##           : The resource location without whitespace.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_568244 = path.getOrDefault("subscriptionId")
  valid_568244 = validateParameter(valid_568244, JString, required = true,
                                 default = nil)
  if valid_568244 != nil:
    section.add "subscriptionId", valid_568244
  var valid_568245 = path.getOrDefault("location")
  valid_568245 = validateParameter(valid_568245, JString, required = true,
                                 default = nil)
  if valid_568245 != nil:
    section.add "location", valid_568245
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568246 = query.getOrDefault("api-version")
  valid_568246 = validateParameter(valid_568246, JString, required = true,
                                 default = nil)
  if valid_568246 != nil:
    section.add "api-version", valid_568246
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters supplied to check the Data Lake Analytics account name availability.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568248: Call_AccountsCheckNameAvailability_568224; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Checks whether the specified account name is available or taken.
  ## 
  let valid = call_568248.validator(path, query, header, formData, body)
  let scheme = call_568248.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568248.url(scheme.get, call_568248.host, call_568248.base,
                         call_568248.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568248, url, valid)

proc call*(call_568249: Call_AccountsCheckNameAvailability_568224;
          apiVersion: string; subscriptionId: string; parameters: JsonNode;
          location: string): Recallable =
  ## accountsCheckNameAvailability
  ## Checks whether the specified account name is available or taken.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Get subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to check the Data Lake Analytics account name availability.
  ##   location: string (required)
  ##           : The resource location without whitespace.
  var path_568250 = newJObject()
  var query_568251 = newJObject()
  var body_568252 = newJObject()
  add(query_568251, "api-version", newJString(apiVersion))
  add(path_568250, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_568252 = parameters
  add(path_568250, "location", newJString(location))
  result = call_568249.call(path_568250, query_568251, nil, nil, body_568252)

var accountsCheckNameAvailability* = Call_AccountsCheckNameAvailability_568224(
    name: "accountsCheckNameAvailability", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.DataLakeAnalytics/locations/{location}/checkNameAvailability",
    validator: validate_AccountsCheckNameAvailability_568225, base: "",
    url: url_AccountsCheckNameAvailability_568226, schemes: {Scheme.Https})
type
  Call_AccountsListByResourceGroup_568253 = ref object of OpenApiRestCall_567666
proc url_AccountsListByResourceGroup_568255(protocol: Scheme; host: string;
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

proc validate_AccountsListByResourceGroup_568254(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the first page of Data Lake Analytics accounts, if any, within a specific resource group. This includes a link to the next page, if any.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the Azure resource group.
  ##   subscriptionId: JString (required)
  ##                 : Get subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568256 = path.getOrDefault("resourceGroupName")
  valid_568256 = validateParameter(valid_568256, JString, required = true,
                                 default = nil)
  if valid_568256 != nil:
    section.add "resourceGroupName", valid_568256
  var valid_568257 = path.getOrDefault("subscriptionId")
  valid_568257 = validateParameter(valid_568257, JString, required = true,
                                 default = nil)
  if valid_568257 != nil:
    section.add "subscriptionId", valid_568257
  result.add "path", section
  ## parameters in `query` object:
  ##   $orderby: JString
  ##           : OrderBy clause. One or more comma-separated expressions with an optional "asc" (the default) or "desc" depending on the order you'd like the values sorted, e.g. Categories?$orderby=CategoryName desc. Optional.
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
  ##   $filter: JString
  ##          : OData filter. Optional.
  section = newJObject()
  var valid_568258 = query.getOrDefault("$orderby")
  valid_568258 = validateParameter(valid_568258, JString, required = false,
                                 default = nil)
  if valid_568258 != nil:
    section.add "$orderby", valid_568258
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568259 = query.getOrDefault("api-version")
  valid_568259 = validateParameter(valid_568259, JString, required = true,
                                 default = nil)
  if valid_568259 != nil:
    section.add "api-version", valid_568259
  var valid_568260 = query.getOrDefault("$top")
  valid_568260 = validateParameter(valid_568260, JInt, required = false, default = nil)
  if valid_568260 != nil:
    section.add "$top", valid_568260
  var valid_568261 = query.getOrDefault("$select")
  valid_568261 = validateParameter(valid_568261, JString, required = false,
                                 default = nil)
  if valid_568261 != nil:
    section.add "$select", valid_568261
  var valid_568262 = query.getOrDefault("$skip")
  valid_568262 = validateParameter(valid_568262, JInt, required = false, default = nil)
  if valid_568262 != nil:
    section.add "$skip", valid_568262
  var valid_568263 = query.getOrDefault("$count")
  valid_568263 = validateParameter(valid_568263, JBool, required = false, default = nil)
  if valid_568263 != nil:
    section.add "$count", valid_568263
  var valid_568264 = query.getOrDefault("$filter")
  valid_568264 = validateParameter(valid_568264, JString, required = false,
                                 default = nil)
  if valid_568264 != nil:
    section.add "$filter", valid_568264
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568265: Call_AccountsListByResourceGroup_568253; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the first page of Data Lake Analytics accounts, if any, within a specific resource group. This includes a link to the next page, if any.
  ## 
  let valid = call_568265.validator(path, query, header, formData, body)
  let scheme = call_568265.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568265.url(scheme.get, call_568265.host, call_568265.base,
                         call_568265.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568265, url, valid)

proc call*(call_568266: Call_AccountsListByResourceGroup_568253;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          Orderby: string = ""; Top: int = 0; Select: string = ""; Skip: int = 0;
          Count: bool = false; Filter: string = ""): Recallable =
  ## accountsListByResourceGroup
  ## Gets the first page of Data Lake Analytics accounts, if any, within a specific resource group. This includes a link to the next page, if any.
  ##   Orderby: string
  ##          : OrderBy clause. One or more comma-separated expressions with an optional "asc" (the default) or "desc" depending on the order you'd like the values sorted, e.g. Categories?$orderby=CategoryName desc. Optional.
  ##   resourceGroupName: string (required)
  ##                    : The name of the Azure resource group.
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
  ##   Filter: string
  ##         : OData filter. Optional.
  var path_568267 = newJObject()
  var query_568268 = newJObject()
  add(query_568268, "$orderby", newJString(Orderby))
  add(path_568267, "resourceGroupName", newJString(resourceGroupName))
  add(query_568268, "api-version", newJString(apiVersion))
  add(path_568267, "subscriptionId", newJString(subscriptionId))
  add(query_568268, "$top", newJInt(Top))
  add(query_568268, "$select", newJString(Select))
  add(query_568268, "$skip", newJInt(Skip))
  add(query_568268, "$count", newJBool(Count))
  add(query_568268, "$filter", newJString(Filter))
  result = call_568266.call(path_568267, query_568268, nil, nil, nil)

var accountsListByResourceGroup* = Call_AccountsListByResourceGroup_568253(
    name: "accountsListByResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataLakeAnalytics/accounts",
    validator: validate_AccountsListByResourceGroup_568254, base: "",
    url: url_AccountsListByResourceGroup_568255, schemes: {Scheme.Https})
type
  Call_AccountsCreate_568280 = ref object of OpenApiRestCall_567666
proc url_AccountsCreate_568282(protocol: Scheme; host: string; base: string;
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

proc validate_AccountsCreate_568281(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Creates the specified Data Lake Analytics account. This supplies the user with computation services for Data Lake Analytics workloads.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the Azure resource group.
  ##   subscriptionId: JString (required)
  ##                 : Get subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   accountName: JString (required)
  ##              : The name of the Data Lake Analytics account.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568283 = path.getOrDefault("resourceGroupName")
  valid_568283 = validateParameter(valid_568283, JString, required = true,
                                 default = nil)
  if valid_568283 != nil:
    section.add "resourceGroupName", valid_568283
  var valid_568284 = path.getOrDefault("subscriptionId")
  valid_568284 = validateParameter(valid_568284, JString, required = true,
                                 default = nil)
  if valid_568284 != nil:
    section.add "subscriptionId", valid_568284
  var valid_568285 = path.getOrDefault("accountName")
  valid_568285 = validateParameter(valid_568285, JString, required = true,
                                 default = nil)
  if valid_568285 != nil:
    section.add "accountName", valid_568285
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568286 = query.getOrDefault("api-version")
  valid_568286 = validateParameter(valid_568286, JString, required = true,
                                 default = nil)
  if valid_568286 != nil:
    section.add "api-version", valid_568286
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters supplied to create a new Data Lake Analytics account.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568288: Call_AccountsCreate_568280; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates the specified Data Lake Analytics account. This supplies the user with computation services for Data Lake Analytics workloads.
  ## 
  let valid = call_568288.validator(path, query, header, formData, body)
  let scheme = call_568288.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568288.url(scheme.get, call_568288.host, call_568288.base,
                         call_568288.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568288, url, valid)

proc call*(call_568289: Call_AccountsCreate_568280; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; parameters: JsonNode;
          accountName: string): Recallable =
  ## accountsCreate
  ## Creates the specified Data Lake Analytics account. This supplies the user with computation services for Data Lake Analytics workloads.
  ##   resourceGroupName: string (required)
  ##                    : The name of the Azure resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Get subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to create a new Data Lake Analytics account.
  ##   accountName: string (required)
  ##              : The name of the Data Lake Analytics account.
  var path_568290 = newJObject()
  var query_568291 = newJObject()
  var body_568292 = newJObject()
  add(path_568290, "resourceGroupName", newJString(resourceGroupName))
  add(query_568291, "api-version", newJString(apiVersion))
  add(path_568290, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_568292 = parameters
  add(path_568290, "accountName", newJString(accountName))
  result = call_568289.call(path_568290, query_568291, nil, nil, body_568292)

var accountsCreate* = Call_AccountsCreate_568280(name: "accountsCreate",
    meth: HttpMethod.HttpPut, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataLakeAnalytics/accounts/{accountName}",
    validator: validate_AccountsCreate_568281, base: "", url: url_AccountsCreate_568282,
    schemes: {Scheme.Https})
type
  Call_AccountsGet_568269 = ref object of OpenApiRestCall_567666
proc url_AccountsGet_568271(protocol: Scheme; host: string; base: string;
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

proc validate_AccountsGet_568270(path: JsonNode; query: JsonNode; header: JsonNode;
                                formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets details of the specified Data Lake Analytics account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the Azure resource group.
  ##   subscriptionId: JString (required)
  ##                 : Get subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   accountName: JString (required)
  ##              : The name of the Data Lake Analytics account.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568272 = path.getOrDefault("resourceGroupName")
  valid_568272 = validateParameter(valid_568272, JString, required = true,
                                 default = nil)
  if valid_568272 != nil:
    section.add "resourceGroupName", valid_568272
  var valid_568273 = path.getOrDefault("subscriptionId")
  valid_568273 = validateParameter(valid_568273, JString, required = true,
                                 default = nil)
  if valid_568273 != nil:
    section.add "subscriptionId", valid_568273
  var valid_568274 = path.getOrDefault("accountName")
  valid_568274 = validateParameter(valid_568274, JString, required = true,
                                 default = nil)
  if valid_568274 != nil:
    section.add "accountName", valid_568274
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568275 = query.getOrDefault("api-version")
  valid_568275 = validateParameter(valid_568275, JString, required = true,
                                 default = nil)
  if valid_568275 != nil:
    section.add "api-version", valid_568275
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568276: Call_AccountsGet_568269; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets details of the specified Data Lake Analytics account.
  ## 
  let valid = call_568276.validator(path, query, header, formData, body)
  let scheme = call_568276.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568276.url(scheme.get, call_568276.host, call_568276.base,
                         call_568276.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568276, url, valid)

proc call*(call_568277: Call_AccountsGet_568269; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; accountName: string): Recallable =
  ## accountsGet
  ## Gets details of the specified Data Lake Analytics account.
  ##   resourceGroupName: string (required)
  ##                    : The name of the Azure resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Get subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   accountName: string (required)
  ##              : The name of the Data Lake Analytics account.
  var path_568278 = newJObject()
  var query_568279 = newJObject()
  add(path_568278, "resourceGroupName", newJString(resourceGroupName))
  add(query_568279, "api-version", newJString(apiVersion))
  add(path_568278, "subscriptionId", newJString(subscriptionId))
  add(path_568278, "accountName", newJString(accountName))
  result = call_568277.call(path_568278, query_568279, nil, nil, nil)

var accountsGet* = Call_AccountsGet_568269(name: "accountsGet",
                                        meth: HttpMethod.HttpGet,
                                        host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataLakeAnalytics/accounts/{accountName}",
                                        validator: validate_AccountsGet_568270,
                                        base: "", url: url_AccountsGet_568271,
                                        schemes: {Scheme.Https})
type
  Call_AccountsUpdate_568304 = ref object of OpenApiRestCall_567666
proc url_AccountsUpdate_568306(protocol: Scheme; host: string; base: string;
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

proc validate_AccountsUpdate_568305(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Updates the Data Lake Analytics account object specified by the accountName with the contents of the account object.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the Azure resource group.
  ##   subscriptionId: JString (required)
  ##                 : Get subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   accountName: JString (required)
  ##              : The name of the Data Lake Analytics account.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568307 = path.getOrDefault("resourceGroupName")
  valid_568307 = validateParameter(valid_568307, JString, required = true,
                                 default = nil)
  if valid_568307 != nil:
    section.add "resourceGroupName", valid_568307
  var valid_568308 = path.getOrDefault("subscriptionId")
  valid_568308 = validateParameter(valid_568308, JString, required = true,
                                 default = nil)
  if valid_568308 != nil:
    section.add "subscriptionId", valid_568308
  var valid_568309 = path.getOrDefault("accountName")
  valid_568309 = validateParameter(valid_568309, JString, required = true,
                                 default = nil)
  if valid_568309 != nil:
    section.add "accountName", valid_568309
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568310 = query.getOrDefault("api-version")
  valid_568310 = validateParameter(valid_568310, JString, required = true,
                                 default = nil)
  if valid_568310 != nil:
    section.add "api-version", valid_568310
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject
  ##             : Parameters supplied to the update Data Lake Analytics account operation.
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568312: Call_AccountsUpdate_568304; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the Data Lake Analytics account object specified by the accountName with the contents of the account object.
  ## 
  let valid = call_568312.validator(path, query, header, formData, body)
  let scheme = call_568312.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568312.url(scheme.get, call_568312.host, call_568312.base,
                         call_568312.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568312, url, valid)

proc call*(call_568313: Call_AccountsUpdate_568304; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; accountName: string;
          parameters: JsonNode = nil): Recallable =
  ## accountsUpdate
  ## Updates the Data Lake Analytics account object specified by the accountName with the contents of the account object.
  ##   resourceGroupName: string (required)
  ##                    : The name of the Azure resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Get subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   parameters: JObject
  ##             : Parameters supplied to the update Data Lake Analytics account operation.
  ##   accountName: string (required)
  ##              : The name of the Data Lake Analytics account.
  var path_568314 = newJObject()
  var query_568315 = newJObject()
  var body_568316 = newJObject()
  add(path_568314, "resourceGroupName", newJString(resourceGroupName))
  add(query_568315, "api-version", newJString(apiVersion))
  add(path_568314, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_568316 = parameters
  add(path_568314, "accountName", newJString(accountName))
  result = call_568313.call(path_568314, query_568315, nil, nil, body_568316)

var accountsUpdate* = Call_AccountsUpdate_568304(name: "accountsUpdate",
    meth: HttpMethod.HttpPatch, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataLakeAnalytics/accounts/{accountName}",
    validator: validate_AccountsUpdate_568305, base: "", url: url_AccountsUpdate_568306,
    schemes: {Scheme.Https})
type
  Call_AccountsDelete_568293 = ref object of OpenApiRestCall_567666
proc url_AccountsDelete_568295(protocol: Scheme; host: string; base: string;
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

proc validate_AccountsDelete_568294(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Begins the delete process for the Data Lake Analytics account object specified by the account name.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the Azure resource group.
  ##   subscriptionId: JString (required)
  ##                 : Get subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   accountName: JString (required)
  ##              : The name of the Data Lake Analytics account.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568296 = path.getOrDefault("resourceGroupName")
  valid_568296 = validateParameter(valid_568296, JString, required = true,
                                 default = nil)
  if valid_568296 != nil:
    section.add "resourceGroupName", valid_568296
  var valid_568297 = path.getOrDefault("subscriptionId")
  valid_568297 = validateParameter(valid_568297, JString, required = true,
                                 default = nil)
  if valid_568297 != nil:
    section.add "subscriptionId", valid_568297
  var valid_568298 = path.getOrDefault("accountName")
  valid_568298 = validateParameter(valid_568298, JString, required = true,
                                 default = nil)
  if valid_568298 != nil:
    section.add "accountName", valid_568298
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568299 = query.getOrDefault("api-version")
  valid_568299 = validateParameter(valid_568299, JString, required = true,
                                 default = nil)
  if valid_568299 != nil:
    section.add "api-version", valid_568299
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568300: Call_AccountsDelete_568293; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Begins the delete process for the Data Lake Analytics account object specified by the account name.
  ## 
  let valid = call_568300.validator(path, query, header, formData, body)
  let scheme = call_568300.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568300.url(scheme.get, call_568300.host, call_568300.base,
                         call_568300.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568300, url, valid)

proc call*(call_568301: Call_AccountsDelete_568293; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; accountName: string): Recallable =
  ## accountsDelete
  ## Begins the delete process for the Data Lake Analytics account object specified by the account name.
  ##   resourceGroupName: string (required)
  ##                    : The name of the Azure resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Get subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   accountName: string (required)
  ##              : The name of the Data Lake Analytics account.
  var path_568302 = newJObject()
  var query_568303 = newJObject()
  add(path_568302, "resourceGroupName", newJString(resourceGroupName))
  add(query_568303, "api-version", newJString(apiVersion))
  add(path_568302, "subscriptionId", newJString(subscriptionId))
  add(path_568302, "accountName", newJString(accountName))
  result = call_568301.call(path_568302, query_568303, nil, nil, nil)

var accountsDelete* = Call_AccountsDelete_568293(name: "accountsDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataLakeAnalytics/accounts/{accountName}",
    validator: validate_AccountsDelete_568294, base: "", url: url_AccountsDelete_568295,
    schemes: {Scheme.Https})
type
  Call_ComputePoliciesListByAccount_568317 = ref object of OpenApiRestCall_567666
proc url_ComputePoliciesListByAccount_568319(protocol: Scheme; host: string;
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
               (kind: ConstantSegment, value: "/computePolicies")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ComputePoliciesListByAccount_568318(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists the Data Lake Analytics compute policies within the specified Data Lake Analytics account. An account supports, at most, 50 policies
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the Azure resource group.
  ##   subscriptionId: JString (required)
  ##                 : Get subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   accountName: JString (required)
  ##              : The name of the Data Lake Analytics account.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568320 = path.getOrDefault("resourceGroupName")
  valid_568320 = validateParameter(valid_568320, JString, required = true,
                                 default = nil)
  if valid_568320 != nil:
    section.add "resourceGroupName", valid_568320
  var valid_568321 = path.getOrDefault("subscriptionId")
  valid_568321 = validateParameter(valid_568321, JString, required = true,
                                 default = nil)
  if valid_568321 != nil:
    section.add "subscriptionId", valid_568321
  var valid_568322 = path.getOrDefault("accountName")
  valid_568322 = validateParameter(valid_568322, JString, required = true,
                                 default = nil)
  if valid_568322 != nil:
    section.add "accountName", valid_568322
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568323 = query.getOrDefault("api-version")
  valid_568323 = validateParameter(valid_568323, JString, required = true,
                                 default = nil)
  if valid_568323 != nil:
    section.add "api-version", valid_568323
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568324: Call_ComputePoliciesListByAccount_568317; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the Data Lake Analytics compute policies within the specified Data Lake Analytics account. An account supports, at most, 50 policies
  ## 
  let valid = call_568324.validator(path, query, header, formData, body)
  let scheme = call_568324.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568324.url(scheme.get, call_568324.host, call_568324.base,
                         call_568324.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568324, url, valid)

proc call*(call_568325: Call_ComputePoliciesListByAccount_568317;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          accountName: string): Recallable =
  ## computePoliciesListByAccount
  ## Lists the Data Lake Analytics compute policies within the specified Data Lake Analytics account. An account supports, at most, 50 policies
  ##   resourceGroupName: string (required)
  ##                    : The name of the Azure resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Get subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   accountName: string (required)
  ##              : The name of the Data Lake Analytics account.
  var path_568326 = newJObject()
  var query_568327 = newJObject()
  add(path_568326, "resourceGroupName", newJString(resourceGroupName))
  add(query_568327, "api-version", newJString(apiVersion))
  add(path_568326, "subscriptionId", newJString(subscriptionId))
  add(path_568326, "accountName", newJString(accountName))
  result = call_568325.call(path_568326, query_568327, nil, nil, nil)

var computePoliciesListByAccount* = Call_ComputePoliciesListByAccount_568317(
    name: "computePoliciesListByAccount", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataLakeAnalytics/accounts/{accountName}/computePolicies",
    validator: validate_ComputePoliciesListByAccount_568318, base: "",
    url: url_ComputePoliciesListByAccount_568319, schemes: {Scheme.Https})
type
  Call_ComputePoliciesCreateOrUpdate_568340 = ref object of OpenApiRestCall_567666
proc url_ComputePoliciesCreateOrUpdate_568342(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "accountName" in path, "`accountName` is a required path parameter"
  assert "computePolicyName" in path,
        "`computePolicyName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.DataLakeAnalytics/accounts/"),
               (kind: VariableSegment, value: "accountName"),
               (kind: ConstantSegment, value: "/computePolicies/"),
               (kind: VariableSegment, value: "computePolicyName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ComputePoliciesCreateOrUpdate_568341(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates or updates the specified compute policy. During update, the compute policy with the specified name will be replaced with this new compute policy. An account supports, at most, 50 policies
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the Azure resource group.
  ##   subscriptionId: JString (required)
  ##                 : Get subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   computePolicyName: JString (required)
  ##                    : The name of the compute policy to create or update.
  ##   accountName: JString (required)
  ##              : The name of the Data Lake Analytics account.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568343 = path.getOrDefault("resourceGroupName")
  valid_568343 = validateParameter(valid_568343, JString, required = true,
                                 default = nil)
  if valid_568343 != nil:
    section.add "resourceGroupName", valid_568343
  var valid_568344 = path.getOrDefault("subscriptionId")
  valid_568344 = validateParameter(valid_568344, JString, required = true,
                                 default = nil)
  if valid_568344 != nil:
    section.add "subscriptionId", valid_568344
  var valid_568345 = path.getOrDefault("computePolicyName")
  valid_568345 = validateParameter(valid_568345, JString, required = true,
                                 default = nil)
  if valid_568345 != nil:
    section.add "computePolicyName", valid_568345
  var valid_568346 = path.getOrDefault("accountName")
  valid_568346 = validateParameter(valid_568346, JString, required = true,
                                 default = nil)
  if valid_568346 != nil:
    section.add "accountName", valid_568346
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568347 = query.getOrDefault("api-version")
  valid_568347 = validateParameter(valid_568347, JString, required = true,
                                 default = nil)
  if valid_568347 != nil:
    section.add "api-version", valid_568347
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters supplied to create or update the compute policy. The max degree of parallelism per job property, min priority per job property, or both must be present.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568349: Call_ComputePoliciesCreateOrUpdate_568340; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates or updates the specified compute policy. During update, the compute policy with the specified name will be replaced with this new compute policy. An account supports, at most, 50 policies
  ## 
  let valid = call_568349.validator(path, query, header, formData, body)
  let scheme = call_568349.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568349.url(scheme.get, call_568349.host, call_568349.base,
                         call_568349.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568349, url, valid)

proc call*(call_568350: Call_ComputePoliciesCreateOrUpdate_568340;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          computePolicyName: string; parameters: JsonNode; accountName: string): Recallable =
  ## computePoliciesCreateOrUpdate
  ## Creates or updates the specified compute policy. During update, the compute policy with the specified name will be replaced with this new compute policy. An account supports, at most, 50 policies
  ##   resourceGroupName: string (required)
  ##                    : The name of the Azure resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Get subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   computePolicyName: string (required)
  ##                    : The name of the compute policy to create or update.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to create or update the compute policy. The max degree of parallelism per job property, min priority per job property, or both must be present.
  ##   accountName: string (required)
  ##              : The name of the Data Lake Analytics account.
  var path_568351 = newJObject()
  var query_568352 = newJObject()
  var body_568353 = newJObject()
  add(path_568351, "resourceGroupName", newJString(resourceGroupName))
  add(query_568352, "api-version", newJString(apiVersion))
  add(path_568351, "subscriptionId", newJString(subscriptionId))
  add(path_568351, "computePolicyName", newJString(computePolicyName))
  if parameters != nil:
    body_568353 = parameters
  add(path_568351, "accountName", newJString(accountName))
  result = call_568350.call(path_568351, query_568352, nil, nil, body_568353)

var computePoliciesCreateOrUpdate* = Call_ComputePoliciesCreateOrUpdate_568340(
    name: "computePoliciesCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataLakeAnalytics/accounts/{accountName}/computePolicies/{computePolicyName}",
    validator: validate_ComputePoliciesCreateOrUpdate_568341, base: "",
    url: url_ComputePoliciesCreateOrUpdate_568342, schemes: {Scheme.Https})
type
  Call_ComputePoliciesGet_568328 = ref object of OpenApiRestCall_567666
proc url_ComputePoliciesGet_568330(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "accountName" in path, "`accountName` is a required path parameter"
  assert "computePolicyName" in path,
        "`computePolicyName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.DataLakeAnalytics/accounts/"),
               (kind: VariableSegment, value: "accountName"),
               (kind: ConstantSegment, value: "/computePolicies/"),
               (kind: VariableSegment, value: "computePolicyName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ComputePoliciesGet_568329(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Gets the specified Data Lake Analytics compute policy.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the Azure resource group.
  ##   subscriptionId: JString (required)
  ##                 : Get subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   computePolicyName: JString (required)
  ##                    : The name of the compute policy to retrieve.
  ##   accountName: JString (required)
  ##              : The name of the Data Lake Analytics account.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568331 = path.getOrDefault("resourceGroupName")
  valid_568331 = validateParameter(valid_568331, JString, required = true,
                                 default = nil)
  if valid_568331 != nil:
    section.add "resourceGroupName", valid_568331
  var valid_568332 = path.getOrDefault("subscriptionId")
  valid_568332 = validateParameter(valid_568332, JString, required = true,
                                 default = nil)
  if valid_568332 != nil:
    section.add "subscriptionId", valid_568332
  var valid_568333 = path.getOrDefault("computePolicyName")
  valid_568333 = validateParameter(valid_568333, JString, required = true,
                                 default = nil)
  if valid_568333 != nil:
    section.add "computePolicyName", valid_568333
  var valid_568334 = path.getOrDefault("accountName")
  valid_568334 = validateParameter(valid_568334, JString, required = true,
                                 default = nil)
  if valid_568334 != nil:
    section.add "accountName", valid_568334
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568335 = query.getOrDefault("api-version")
  valid_568335 = validateParameter(valid_568335, JString, required = true,
                                 default = nil)
  if valid_568335 != nil:
    section.add "api-version", valid_568335
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568336: Call_ComputePoliciesGet_568328; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the specified Data Lake Analytics compute policy.
  ## 
  let valid = call_568336.validator(path, query, header, formData, body)
  let scheme = call_568336.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568336.url(scheme.get, call_568336.host, call_568336.base,
                         call_568336.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568336, url, valid)

proc call*(call_568337: Call_ComputePoliciesGet_568328; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; computePolicyName: string;
          accountName: string): Recallable =
  ## computePoliciesGet
  ## Gets the specified Data Lake Analytics compute policy.
  ##   resourceGroupName: string (required)
  ##                    : The name of the Azure resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Get subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   computePolicyName: string (required)
  ##                    : The name of the compute policy to retrieve.
  ##   accountName: string (required)
  ##              : The name of the Data Lake Analytics account.
  var path_568338 = newJObject()
  var query_568339 = newJObject()
  add(path_568338, "resourceGroupName", newJString(resourceGroupName))
  add(query_568339, "api-version", newJString(apiVersion))
  add(path_568338, "subscriptionId", newJString(subscriptionId))
  add(path_568338, "computePolicyName", newJString(computePolicyName))
  add(path_568338, "accountName", newJString(accountName))
  result = call_568337.call(path_568338, query_568339, nil, nil, nil)

var computePoliciesGet* = Call_ComputePoliciesGet_568328(
    name: "computePoliciesGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataLakeAnalytics/accounts/{accountName}/computePolicies/{computePolicyName}",
    validator: validate_ComputePoliciesGet_568329, base: "",
    url: url_ComputePoliciesGet_568330, schemes: {Scheme.Https})
type
  Call_ComputePoliciesUpdate_568366 = ref object of OpenApiRestCall_567666
proc url_ComputePoliciesUpdate_568368(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "accountName" in path, "`accountName` is a required path parameter"
  assert "computePolicyName" in path,
        "`computePolicyName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.DataLakeAnalytics/accounts/"),
               (kind: VariableSegment, value: "accountName"),
               (kind: ConstantSegment, value: "/computePolicies/"),
               (kind: VariableSegment, value: "computePolicyName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ComputePoliciesUpdate_568367(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates the specified compute policy.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the Azure resource group.
  ##   subscriptionId: JString (required)
  ##                 : Get subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   computePolicyName: JString (required)
  ##                    : The name of the compute policy to update.
  ##   accountName: JString (required)
  ##              : The name of the Data Lake Analytics account.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568369 = path.getOrDefault("resourceGroupName")
  valid_568369 = validateParameter(valid_568369, JString, required = true,
                                 default = nil)
  if valid_568369 != nil:
    section.add "resourceGroupName", valid_568369
  var valid_568370 = path.getOrDefault("subscriptionId")
  valid_568370 = validateParameter(valid_568370, JString, required = true,
                                 default = nil)
  if valid_568370 != nil:
    section.add "subscriptionId", valid_568370
  var valid_568371 = path.getOrDefault("computePolicyName")
  valid_568371 = validateParameter(valid_568371, JString, required = true,
                                 default = nil)
  if valid_568371 != nil:
    section.add "computePolicyName", valid_568371
  var valid_568372 = path.getOrDefault("accountName")
  valid_568372 = validateParameter(valid_568372, JString, required = true,
                                 default = nil)
  if valid_568372 != nil:
    section.add "accountName", valid_568372
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568373 = query.getOrDefault("api-version")
  valid_568373 = validateParameter(valid_568373, JString, required = true,
                                 default = nil)
  if valid_568373 != nil:
    section.add "api-version", valid_568373
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject
  ##             : Parameters supplied to update the compute policy.
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568375: Call_ComputePoliciesUpdate_568366; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the specified compute policy.
  ## 
  let valid = call_568375.validator(path, query, header, formData, body)
  let scheme = call_568375.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568375.url(scheme.get, call_568375.host, call_568375.base,
                         call_568375.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568375, url, valid)

proc call*(call_568376: Call_ComputePoliciesUpdate_568366;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          computePolicyName: string; accountName: string; parameters: JsonNode = nil): Recallable =
  ## computePoliciesUpdate
  ## Updates the specified compute policy.
  ##   resourceGroupName: string (required)
  ##                    : The name of the Azure resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Get subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   computePolicyName: string (required)
  ##                    : The name of the compute policy to update.
  ##   parameters: JObject
  ##             : Parameters supplied to update the compute policy.
  ##   accountName: string (required)
  ##              : The name of the Data Lake Analytics account.
  var path_568377 = newJObject()
  var query_568378 = newJObject()
  var body_568379 = newJObject()
  add(path_568377, "resourceGroupName", newJString(resourceGroupName))
  add(query_568378, "api-version", newJString(apiVersion))
  add(path_568377, "subscriptionId", newJString(subscriptionId))
  add(path_568377, "computePolicyName", newJString(computePolicyName))
  if parameters != nil:
    body_568379 = parameters
  add(path_568377, "accountName", newJString(accountName))
  result = call_568376.call(path_568377, query_568378, nil, nil, body_568379)

var computePoliciesUpdate* = Call_ComputePoliciesUpdate_568366(
    name: "computePoliciesUpdate", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataLakeAnalytics/accounts/{accountName}/computePolicies/{computePolicyName}",
    validator: validate_ComputePoliciesUpdate_568367, base: "",
    url: url_ComputePoliciesUpdate_568368, schemes: {Scheme.Https})
type
  Call_ComputePoliciesDelete_568354 = ref object of OpenApiRestCall_567666
proc url_ComputePoliciesDelete_568356(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "accountName" in path, "`accountName` is a required path parameter"
  assert "computePolicyName" in path,
        "`computePolicyName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.DataLakeAnalytics/accounts/"),
               (kind: VariableSegment, value: "accountName"),
               (kind: ConstantSegment, value: "/computePolicies/"),
               (kind: VariableSegment, value: "computePolicyName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ComputePoliciesDelete_568355(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes the specified compute policy from the specified Data Lake Analytics account
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the Azure resource group.
  ##   subscriptionId: JString (required)
  ##                 : Get subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   computePolicyName: JString (required)
  ##                    : The name of the compute policy to delete.
  ##   accountName: JString (required)
  ##              : The name of the Data Lake Analytics account.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568357 = path.getOrDefault("resourceGroupName")
  valid_568357 = validateParameter(valid_568357, JString, required = true,
                                 default = nil)
  if valid_568357 != nil:
    section.add "resourceGroupName", valid_568357
  var valid_568358 = path.getOrDefault("subscriptionId")
  valid_568358 = validateParameter(valid_568358, JString, required = true,
                                 default = nil)
  if valid_568358 != nil:
    section.add "subscriptionId", valid_568358
  var valid_568359 = path.getOrDefault("computePolicyName")
  valid_568359 = validateParameter(valid_568359, JString, required = true,
                                 default = nil)
  if valid_568359 != nil:
    section.add "computePolicyName", valid_568359
  var valid_568360 = path.getOrDefault("accountName")
  valid_568360 = validateParameter(valid_568360, JString, required = true,
                                 default = nil)
  if valid_568360 != nil:
    section.add "accountName", valid_568360
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568361 = query.getOrDefault("api-version")
  valid_568361 = validateParameter(valid_568361, JString, required = true,
                                 default = nil)
  if valid_568361 != nil:
    section.add "api-version", valid_568361
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568362: Call_ComputePoliciesDelete_568354; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the specified compute policy from the specified Data Lake Analytics account
  ## 
  let valid = call_568362.validator(path, query, header, formData, body)
  let scheme = call_568362.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568362.url(scheme.get, call_568362.host, call_568362.base,
                         call_568362.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568362, url, valid)

proc call*(call_568363: Call_ComputePoliciesDelete_568354;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          computePolicyName: string; accountName: string): Recallable =
  ## computePoliciesDelete
  ## Deletes the specified compute policy from the specified Data Lake Analytics account
  ##   resourceGroupName: string (required)
  ##                    : The name of the Azure resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Get subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   computePolicyName: string (required)
  ##                    : The name of the compute policy to delete.
  ##   accountName: string (required)
  ##              : The name of the Data Lake Analytics account.
  var path_568364 = newJObject()
  var query_568365 = newJObject()
  add(path_568364, "resourceGroupName", newJString(resourceGroupName))
  add(query_568365, "api-version", newJString(apiVersion))
  add(path_568364, "subscriptionId", newJString(subscriptionId))
  add(path_568364, "computePolicyName", newJString(computePolicyName))
  add(path_568364, "accountName", newJString(accountName))
  result = call_568363.call(path_568364, query_568365, nil, nil, nil)

var computePoliciesDelete* = Call_ComputePoliciesDelete_568354(
    name: "computePoliciesDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataLakeAnalytics/accounts/{accountName}/computePolicies/{computePolicyName}",
    validator: validate_ComputePoliciesDelete_568355, base: "",
    url: url_ComputePoliciesDelete_568356, schemes: {Scheme.Https})
type
  Call_DataLakeStoreAccountsListByAccount_568380 = ref object of OpenApiRestCall_567666
proc url_DataLakeStoreAccountsListByAccount_568382(protocol: Scheme; host: string;
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
               (kind: ConstantSegment, value: "/dataLakeStoreAccounts")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DataLakeStoreAccountsListByAccount_568381(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the first page of Data Lake Store accounts linked to the specified Data Lake Analytics account. The response includes a link to the next page, if any.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the Azure resource group.
  ##   subscriptionId: JString (required)
  ##                 : Get subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   accountName: JString (required)
  ##              : The name of the Data Lake Analytics account.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568383 = path.getOrDefault("resourceGroupName")
  valid_568383 = validateParameter(valid_568383, JString, required = true,
                                 default = nil)
  if valid_568383 != nil:
    section.add "resourceGroupName", valid_568383
  var valid_568384 = path.getOrDefault("subscriptionId")
  valid_568384 = validateParameter(valid_568384, JString, required = true,
                                 default = nil)
  if valid_568384 != nil:
    section.add "subscriptionId", valid_568384
  var valid_568385 = path.getOrDefault("accountName")
  valid_568385 = validateParameter(valid_568385, JString, required = true,
                                 default = nil)
  if valid_568385 != nil:
    section.add "accountName", valid_568385
  result.add "path", section
  ## parameters in `query` object:
  ##   $orderby: JString
  ##           : OrderBy clause. One or more comma-separated expressions with an optional "asc" (the default) or "desc" depending on the order you'd like the values sorted, e.g. Categories?$orderby=CategoryName desc. Optional.
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
  ##   $filter: JString
  ##          : OData filter. Optional.
  section = newJObject()
  var valid_568386 = query.getOrDefault("$orderby")
  valid_568386 = validateParameter(valid_568386, JString, required = false,
                                 default = nil)
  if valid_568386 != nil:
    section.add "$orderby", valid_568386
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568387 = query.getOrDefault("api-version")
  valid_568387 = validateParameter(valid_568387, JString, required = true,
                                 default = nil)
  if valid_568387 != nil:
    section.add "api-version", valid_568387
  var valid_568388 = query.getOrDefault("$top")
  valid_568388 = validateParameter(valid_568388, JInt, required = false, default = nil)
  if valid_568388 != nil:
    section.add "$top", valid_568388
  var valid_568389 = query.getOrDefault("$select")
  valid_568389 = validateParameter(valid_568389, JString, required = false,
                                 default = nil)
  if valid_568389 != nil:
    section.add "$select", valid_568389
  var valid_568390 = query.getOrDefault("$skip")
  valid_568390 = validateParameter(valid_568390, JInt, required = false, default = nil)
  if valid_568390 != nil:
    section.add "$skip", valid_568390
  var valid_568391 = query.getOrDefault("$count")
  valid_568391 = validateParameter(valid_568391, JBool, required = false, default = nil)
  if valid_568391 != nil:
    section.add "$count", valid_568391
  var valid_568392 = query.getOrDefault("$filter")
  valid_568392 = validateParameter(valid_568392, JString, required = false,
                                 default = nil)
  if valid_568392 != nil:
    section.add "$filter", valid_568392
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568393: Call_DataLakeStoreAccountsListByAccount_568380;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the first page of Data Lake Store accounts linked to the specified Data Lake Analytics account. The response includes a link to the next page, if any.
  ## 
  let valid = call_568393.validator(path, query, header, formData, body)
  let scheme = call_568393.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568393.url(scheme.get, call_568393.host, call_568393.base,
                         call_568393.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568393, url, valid)

proc call*(call_568394: Call_DataLakeStoreAccountsListByAccount_568380;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          accountName: string; Orderby: string = ""; Top: int = 0; Select: string = "";
          Skip: int = 0; Count: bool = false; Filter: string = ""): Recallable =
  ## dataLakeStoreAccountsListByAccount
  ## Gets the first page of Data Lake Store accounts linked to the specified Data Lake Analytics account. The response includes a link to the next page, if any.
  ##   Orderby: string
  ##          : OrderBy clause. One or more comma-separated expressions with an optional "asc" (the default) or "desc" depending on the order you'd like the values sorted, e.g. Categories?$orderby=CategoryName desc. Optional.
  ##   resourceGroupName: string (required)
  ##                    : The name of the Azure resource group.
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
  ##   accountName: string (required)
  ##              : The name of the Data Lake Analytics account.
  ##   Filter: string
  ##         : OData filter. Optional.
  var path_568395 = newJObject()
  var query_568396 = newJObject()
  add(query_568396, "$orderby", newJString(Orderby))
  add(path_568395, "resourceGroupName", newJString(resourceGroupName))
  add(query_568396, "api-version", newJString(apiVersion))
  add(path_568395, "subscriptionId", newJString(subscriptionId))
  add(query_568396, "$top", newJInt(Top))
  add(query_568396, "$select", newJString(Select))
  add(query_568396, "$skip", newJInt(Skip))
  add(query_568396, "$count", newJBool(Count))
  add(path_568395, "accountName", newJString(accountName))
  add(query_568396, "$filter", newJString(Filter))
  result = call_568394.call(path_568395, query_568396, nil, nil, nil)

var dataLakeStoreAccountsListByAccount* = Call_DataLakeStoreAccountsListByAccount_568380(
    name: "dataLakeStoreAccountsListByAccount", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataLakeAnalytics/accounts/{accountName}/dataLakeStoreAccounts",
    validator: validate_DataLakeStoreAccountsListByAccount_568381, base: "",
    url: url_DataLakeStoreAccountsListByAccount_568382, schemes: {Scheme.Https})
type
  Call_DataLakeStoreAccountsAdd_568409 = ref object of OpenApiRestCall_567666
proc url_DataLakeStoreAccountsAdd_568411(protocol: Scheme; host: string;
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
               (kind: ConstantSegment, value: "/dataLakeStoreAccounts/"),
               (kind: VariableSegment, value: "dataLakeStoreAccountName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DataLakeStoreAccountsAdd_568410(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates the specified Data Lake Analytics account to include the additional Data Lake Store account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the Azure resource group.
  ##   subscriptionId: JString (required)
  ##                 : Get subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   dataLakeStoreAccountName: JString (required)
  ##                           : The name of the Data Lake Store account to add.
  ##   accountName: JString (required)
  ##              : The name of the Data Lake Analytics account.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568412 = path.getOrDefault("resourceGroupName")
  valid_568412 = validateParameter(valid_568412, JString, required = true,
                                 default = nil)
  if valid_568412 != nil:
    section.add "resourceGroupName", valid_568412
  var valid_568413 = path.getOrDefault("subscriptionId")
  valid_568413 = validateParameter(valid_568413, JString, required = true,
                                 default = nil)
  if valid_568413 != nil:
    section.add "subscriptionId", valid_568413
  var valid_568414 = path.getOrDefault("dataLakeStoreAccountName")
  valid_568414 = validateParameter(valid_568414, JString, required = true,
                                 default = nil)
  if valid_568414 != nil:
    section.add "dataLakeStoreAccountName", valid_568414
  var valid_568415 = path.getOrDefault("accountName")
  valid_568415 = validateParameter(valid_568415, JString, required = true,
                                 default = nil)
  if valid_568415 != nil:
    section.add "accountName", valid_568415
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568416 = query.getOrDefault("api-version")
  valid_568416 = validateParameter(valid_568416, JString, required = true,
                                 default = nil)
  if valid_568416 != nil:
    section.add "api-version", valid_568416
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject
  ##             : The details of the Data Lake Store account.
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568418: Call_DataLakeStoreAccountsAdd_568409; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the specified Data Lake Analytics account to include the additional Data Lake Store account.
  ## 
  let valid = call_568418.validator(path, query, header, formData, body)
  let scheme = call_568418.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568418.url(scheme.get, call_568418.host, call_568418.base,
                         call_568418.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568418, url, valid)

proc call*(call_568419: Call_DataLakeStoreAccountsAdd_568409;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          dataLakeStoreAccountName: string; accountName: string;
          parameters: JsonNode = nil): Recallable =
  ## dataLakeStoreAccountsAdd
  ## Updates the specified Data Lake Analytics account to include the additional Data Lake Store account.
  ##   resourceGroupName: string (required)
  ##                    : The name of the Azure resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Get subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   parameters: JObject
  ##             : The details of the Data Lake Store account.
  ##   dataLakeStoreAccountName: string (required)
  ##                           : The name of the Data Lake Store account to add.
  ##   accountName: string (required)
  ##              : The name of the Data Lake Analytics account.
  var path_568420 = newJObject()
  var query_568421 = newJObject()
  var body_568422 = newJObject()
  add(path_568420, "resourceGroupName", newJString(resourceGroupName))
  add(query_568421, "api-version", newJString(apiVersion))
  add(path_568420, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_568422 = parameters
  add(path_568420, "dataLakeStoreAccountName",
      newJString(dataLakeStoreAccountName))
  add(path_568420, "accountName", newJString(accountName))
  result = call_568419.call(path_568420, query_568421, nil, nil, body_568422)

var dataLakeStoreAccountsAdd* = Call_DataLakeStoreAccountsAdd_568409(
    name: "dataLakeStoreAccountsAdd", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataLakeAnalytics/accounts/{accountName}/dataLakeStoreAccounts/{dataLakeStoreAccountName}",
    validator: validate_DataLakeStoreAccountsAdd_568410, base: "",
    url: url_DataLakeStoreAccountsAdd_568411, schemes: {Scheme.Https})
type
  Call_DataLakeStoreAccountsGet_568397 = ref object of OpenApiRestCall_567666
proc url_DataLakeStoreAccountsGet_568399(protocol: Scheme; host: string;
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
               (kind: ConstantSegment, value: "/dataLakeStoreAccounts/"),
               (kind: VariableSegment, value: "dataLakeStoreAccountName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DataLakeStoreAccountsGet_568398(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the specified Data Lake Store account details in the specified Data Lake Analytics account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the Azure resource group.
  ##   subscriptionId: JString (required)
  ##                 : Get subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   dataLakeStoreAccountName: JString (required)
  ##                           : The name of the Data Lake Store account to retrieve
  ##   accountName: JString (required)
  ##              : The name of the Data Lake Analytics account.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568400 = path.getOrDefault("resourceGroupName")
  valid_568400 = validateParameter(valid_568400, JString, required = true,
                                 default = nil)
  if valid_568400 != nil:
    section.add "resourceGroupName", valid_568400
  var valid_568401 = path.getOrDefault("subscriptionId")
  valid_568401 = validateParameter(valid_568401, JString, required = true,
                                 default = nil)
  if valid_568401 != nil:
    section.add "subscriptionId", valid_568401
  var valid_568402 = path.getOrDefault("dataLakeStoreAccountName")
  valid_568402 = validateParameter(valid_568402, JString, required = true,
                                 default = nil)
  if valid_568402 != nil:
    section.add "dataLakeStoreAccountName", valid_568402
  var valid_568403 = path.getOrDefault("accountName")
  valid_568403 = validateParameter(valid_568403, JString, required = true,
                                 default = nil)
  if valid_568403 != nil:
    section.add "accountName", valid_568403
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568404 = query.getOrDefault("api-version")
  valid_568404 = validateParameter(valid_568404, JString, required = true,
                                 default = nil)
  if valid_568404 != nil:
    section.add "api-version", valid_568404
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568405: Call_DataLakeStoreAccountsGet_568397; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the specified Data Lake Store account details in the specified Data Lake Analytics account.
  ## 
  let valid = call_568405.validator(path, query, header, formData, body)
  let scheme = call_568405.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568405.url(scheme.get, call_568405.host, call_568405.base,
                         call_568405.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568405, url, valid)

proc call*(call_568406: Call_DataLakeStoreAccountsGet_568397;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          dataLakeStoreAccountName: string; accountName: string): Recallable =
  ## dataLakeStoreAccountsGet
  ## Gets the specified Data Lake Store account details in the specified Data Lake Analytics account.
  ##   resourceGroupName: string (required)
  ##                    : The name of the Azure resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Get subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   dataLakeStoreAccountName: string (required)
  ##                           : The name of the Data Lake Store account to retrieve
  ##   accountName: string (required)
  ##              : The name of the Data Lake Analytics account.
  var path_568407 = newJObject()
  var query_568408 = newJObject()
  add(path_568407, "resourceGroupName", newJString(resourceGroupName))
  add(query_568408, "api-version", newJString(apiVersion))
  add(path_568407, "subscriptionId", newJString(subscriptionId))
  add(path_568407, "dataLakeStoreAccountName",
      newJString(dataLakeStoreAccountName))
  add(path_568407, "accountName", newJString(accountName))
  result = call_568406.call(path_568407, query_568408, nil, nil, nil)

var dataLakeStoreAccountsGet* = Call_DataLakeStoreAccountsGet_568397(
    name: "dataLakeStoreAccountsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataLakeAnalytics/accounts/{accountName}/dataLakeStoreAccounts/{dataLakeStoreAccountName}",
    validator: validate_DataLakeStoreAccountsGet_568398, base: "",
    url: url_DataLakeStoreAccountsGet_568399, schemes: {Scheme.Https})
type
  Call_DataLakeStoreAccountsDelete_568423 = ref object of OpenApiRestCall_567666
proc url_DataLakeStoreAccountsDelete_568425(protocol: Scheme; host: string;
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
               (kind: ConstantSegment, value: "/dataLakeStoreAccounts/"),
               (kind: VariableSegment, value: "dataLakeStoreAccountName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DataLakeStoreAccountsDelete_568424(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates the Data Lake Analytics account specified to remove the specified Data Lake Store account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the Azure resource group.
  ##   subscriptionId: JString (required)
  ##                 : Get subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   dataLakeStoreAccountName: JString (required)
  ##                           : The name of the Data Lake Store account to remove
  ##   accountName: JString (required)
  ##              : The name of the Data Lake Analytics account.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568426 = path.getOrDefault("resourceGroupName")
  valid_568426 = validateParameter(valid_568426, JString, required = true,
                                 default = nil)
  if valid_568426 != nil:
    section.add "resourceGroupName", valid_568426
  var valid_568427 = path.getOrDefault("subscriptionId")
  valid_568427 = validateParameter(valid_568427, JString, required = true,
                                 default = nil)
  if valid_568427 != nil:
    section.add "subscriptionId", valid_568427
  var valid_568428 = path.getOrDefault("dataLakeStoreAccountName")
  valid_568428 = validateParameter(valid_568428, JString, required = true,
                                 default = nil)
  if valid_568428 != nil:
    section.add "dataLakeStoreAccountName", valid_568428
  var valid_568429 = path.getOrDefault("accountName")
  valid_568429 = validateParameter(valid_568429, JString, required = true,
                                 default = nil)
  if valid_568429 != nil:
    section.add "accountName", valid_568429
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
  if body != nil:
    result.add "body", body

proc call*(call_568431: Call_DataLakeStoreAccountsDelete_568423; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the Data Lake Analytics account specified to remove the specified Data Lake Store account.
  ## 
  let valid = call_568431.validator(path, query, header, formData, body)
  let scheme = call_568431.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568431.url(scheme.get, call_568431.host, call_568431.base,
                         call_568431.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568431, url, valid)

proc call*(call_568432: Call_DataLakeStoreAccountsDelete_568423;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          dataLakeStoreAccountName: string; accountName: string): Recallable =
  ## dataLakeStoreAccountsDelete
  ## Updates the Data Lake Analytics account specified to remove the specified Data Lake Store account.
  ##   resourceGroupName: string (required)
  ##                    : The name of the Azure resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Get subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   dataLakeStoreAccountName: string (required)
  ##                           : The name of the Data Lake Store account to remove
  ##   accountName: string (required)
  ##              : The name of the Data Lake Analytics account.
  var path_568433 = newJObject()
  var query_568434 = newJObject()
  add(path_568433, "resourceGroupName", newJString(resourceGroupName))
  add(query_568434, "api-version", newJString(apiVersion))
  add(path_568433, "subscriptionId", newJString(subscriptionId))
  add(path_568433, "dataLakeStoreAccountName",
      newJString(dataLakeStoreAccountName))
  add(path_568433, "accountName", newJString(accountName))
  result = call_568432.call(path_568433, query_568434, nil, nil, nil)

var dataLakeStoreAccountsDelete* = Call_DataLakeStoreAccountsDelete_568423(
    name: "dataLakeStoreAccountsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataLakeAnalytics/accounts/{accountName}/dataLakeStoreAccounts/{dataLakeStoreAccountName}",
    validator: validate_DataLakeStoreAccountsDelete_568424, base: "",
    url: url_DataLakeStoreAccountsDelete_568425, schemes: {Scheme.Https})
type
  Call_FirewallRulesListByAccount_568435 = ref object of OpenApiRestCall_567666
proc url_FirewallRulesListByAccount_568437(protocol: Scheme; host: string;
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
               (kind: ConstantSegment, value: "/firewallRules")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_FirewallRulesListByAccount_568436(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists the Data Lake Analytics firewall rules within the specified Data Lake Analytics account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the Azure resource group.
  ##   subscriptionId: JString (required)
  ##                 : Get subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   accountName: JString (required)
  ##              : The name of the Data Lake Analytics account.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568438 = path.getOrDefault("resourceGroupName")
  valid_568438 = validateParameter(valid_568438, JString, required = true,
                                 default = nil)
  if valid_568438 != nil:
    section.add "resourceGroupName", valid_568438
  var valid_568439 = path.getOrDefault("subscriptionId")
  valid_568439 = validateParameter(valid_568439, JString, required = true,
                                 default = nil)
  if valid_568439 != nil:
    section.add "subscriptionId", valid_568439
  var valid_568440 = path.getOrDefault("accountName")
  valid_568440 = validateParameter(valid_568440, JString, required = true,
                                 default = nil)
  if valid_568440 != nil:
    section.add "accountName", valid_568440
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568441 = query.getOrDefault("api-version")
  valid_568441 = validateParameter(valid_568441, JString, required = true,
                                 default = nil)
  if valid_568441 != nil:
    section.add "api-version", valid_568441
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568442: Call_FirewallRulesListByAccount_568435; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the Data Lake Analytics firewall rules within the specified Data Lake Analytics account.
  ## 
  let valid = call_568442.validator(path, query, header, formData, body)
  let scheme = call_568442.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568442.url(scheme.get, call_568442.host, call_568442.base,
                         call_568442.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568442, url, valid)

proc call*(call_568443: Call_FirewallRulesListByAccount_568435;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          accountName: string): Recallable =
  ## firewallRulesListByAccount
  ## Lists the Data Lake Analytics firewall rules within the specified Data Lake Analytics account.
  ##   resourceGroupName: string (required)
  ##                    : The name of the Azure resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Get subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   accountName: string (required)
  ##              : The name of the Data Lake Analytics account.
  var path_568444 = newJObject()
  var query_568445 = newJObject()
  add(path_568444, "resourceGroupName", newJString(resourceGroupName))
  add(query_568445, "api-version", newJString(apiVersion))
  add(path_568444, "subscriptionId", newJString(subscriptionId))
  add(path_568444, "accountName", newJString(accountName))
  result = call_568443.call(path_568444, query_568445, nil, nil, nil)

var firewallRulesListByAccount* = Call_FirewallRulesListByAccount_568435(
    name: "firewallRulesListByAccount", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataLakeAnalytics/accounts/{accountName}/firewallRules",
    validator: validate_FirewallRulesListByAccount_568436, base: "",
    url: url_FirewallRulesListByAccount_568437, schemes: {Scheme.Https})
type
  Call_FirewallRulesCreateOrUpdate_568458 = ref object of OpenApiRestCall_567666
proc url_FirewallRulesCreateOrUpdate_568460(protocol: Scheme; host: string;
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
        value: "/providers/Microsoft.DataLakeAnalytics/accounts/"),
               (kind: VariableSegment, value: "accountName"),
               (kind: ConstantSegment, value: "/firewallRules/"),
               (kind: VariableSegment, value: "firewallRuleName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_FirewallRulesCreateOrUpdate_568459(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates or updates the specified firewall rule. During update, the firewall rule with the specified name will be replaced with this new firewall rule.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the Azure resource group.
  ##   subscriptionId: JString (required)
  ##                 : Get subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   firewallRuleName: JString (required)
  ##                   : The name of the firewall rule to create or update.
  ##   accountName: JString (required)
  ##              : The name of the Data Lake Analytics account.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568461 = path.getOrDefault("resourceGroupName")
  valid_568461 = validateParameter(valid_568461, JString, required = true,
                                 default = nil)
  if valid_568461 != nil:
    section.add "resourceGroupName", valid_568461
  var valid_568462 = path.getOrDefault("subscriptionId")
  valid_568462 = validateParameter(valid_568462, JString, required = true,
                                 default = nil)
  if valid_568462 != nil:
    section.add "subscriptionId", valid_568462
  var valid_568463 = path.getOrDefault("firewallRuleName")
  valid_568463 = validateParameter(valid_568463, JString, required = true,
                                 default = nil)
  if valid_568463 != nil:
    section.add "firewallRuleName", valid_568463
  var valid_568464 = path.getOrDefault("accountName")
  valid_568464 = validateParameter(valid_568464, JString, required = true,
                                 default = nil)
  if valid_568464 != nil:
    section.add "accountName", valid_568464
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568465 = query.getOrDefault("api-version")
  valid_568465 = validateParameter(valid_568465, JString, required = true,
                                 default = nil)
  if valid_568465 != nil:
    section.add "api-version", valid_568465
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters supplied to create or update the firewall rule.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568467: Call_FirewallRulesCreateOrUpdate_568458; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates or updates the specified firewall rule. During update, the firewall rule with the specified name will be replaced with this new firewall rule.
  ## 
  let valid = call_568467.validator(path, query, header, formData, body)
  let scheme = call_568467.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568467.url(scheme.get, call_568467.host, call_568467.base,
                         call_568467.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568467, url, valid)

proc call*(call_568468: Call_FirewallRulesCreateOrUpdate_568458;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          parameters: JsonNode; firewallRuleName: string; accountName: string): Recallable =
  ## firewallRulesCreateOrUpdate
  ## Creates or updates the specified firewall rule. During update, the firewall rule with the specified name will be replaced with this new firewall rule.
  ##   resourceGroupName: string (required)
  ##                    : The name of the Azure resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Get subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to create or update the firewall rule.
  ##   firewallRuleName: string (required)
  ##                   : The name of the firewall rule to create or update.
  ##   accountName: string (required)
  ##              : The name of the Data Lake Analytics account.
  var path_568469 = newJObject()
  var query_568470 = newJObject()
  var body_568471 = newJObject()
  add(path_568469, "resourceGroupName", newJString(resourceGroupName))
  add(query_568470, "api-version", newJString(apiVersion))
  add(path_568469, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_568471 = parameters
  add(path_568469, "firewallRuleName", newJString(firewallRuleName))
  add(path_568469, "accountName", newJString(accountName))
  result = call_568468.call(path_568469, query_568470, nil, nil, body_568471)

var firewallRulesCreateOrUpdate* = Call_FirewallRulesCreateOrUpdate_568458(
    name: "firewallRulesCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataLakeAnalytics/accounts/{accountName}/firewallRules/{firewallRuleName}",
    validator: validate_FirewallRulesCreateOrUpdate_568459, base: "",
    url: url_FirewallRulesCreateOrUpdate_568460, schemes: {Scheme.Https})
type
  Call_FirewallRulesGet_568446 = ref object of OpenApiRestCall_567666
proc url_FirewallRulesGet_568448(protocol: Scheme; host: string; base: string;
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
        value: "/providers/Microsoft.DataLakeAnalytics/accounts/"),
               (kind: VariableSegment, value: "accountName"),
               (kind: ConstantSegment, value: "/firewallRules/"),
               (kind: VariableSegment, value: "firewallRuleName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_FirewallRulesGet_568447(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Gets the specified Data Lake Analytics firewall rule.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the Azure resource group.
  ##   subscriptionId: JString (required)
  ##                 : Get subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   firewallRuleName: JString (required)
  ##                   : The name of the firewall rule to retrieve.
  ##   accountName: JString (required)
  ##              : The name of the Data Lake Analytics account.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568449 = path.getOrDefault("resourceGroupName")
  valid_568449 = validateParameter(valid_568449, JString, required = true,
                                 default = nil)
  if valid_568449 != nil:
    section.add "resourceGroupName", valid_568449
  var valid_568450 = path.getOrDefault("subscriptionId")
  valid_568450 = validateParameter(valid_568450, JString, required = true,
                                 default = nil)
  if valid_568450 != nil:
    section.add "subscriptionId", valid_568450
  var valid_568451 = path.getOrDefault("firewallRuleName")
  valid_568451 = validateParameter(valid_568451, JString, required = true,
                                 default = nil)
  if valid_568451 != nil:
    section.add "firewallRuleName", valid_568451
  var valid_568452 = path.getOrDefault("accountName")
  valid_568452 = validateParameter(valid_568452, JString, required = true,
                                 default = nil)
  if valid_568452 != nil:
    section.add "accountName", valid_568452
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568453 = query.getOrDefault("api-version")
  valid_568453 = validateParameter(valid_568453, JString, required = true,
                                 default = nil)
  if valid_568453 != nil:
    section.add "api-version", valid_568453
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568454: Call_FirewallRulesGet_568446; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the specified Data Lake Analytics firewall rule.
  ## 
  let valid = call_568454.validator(path, query, header, formData, body)
  let scheme = call_568454.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568454.url(scheme.get, call_568454.host, call_568454.base,
                         call_568454.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568454, url, valid)

proc call*(call_568455: Call_FirewallRulesGet_568446; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; firewallRuleName: string;
          accountName: string): Recallable =
  ## firewallRulesGet
  ## Gets the specified Data Lake Analytics firewall rule.
  ##   resourceGroupName: string (required)
  ##                    : The name of the Azure resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Get subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   firewallRuleName: string (required)
  ##                   : The name of the firewall rule to retrieve.
  ##   accountName: string (required)
  ##              : The name of the Data Lake Analytics account.
  var path_568456 = newJObject()
  var query_568457 = newJObject()
  add(path_568456, "resourceGroupName", newJString(resourceGroupName))
  add(query_568457, "api-version", newJString(apiVersion))
  add(path_568456, "subscriptionId", newJString(subscriptionId))
  add(path_568456, "firewallRuleName", newJString(firewallRuleName))
  add(path_568456, "accountName", newJString(accountName))
  result = call_568455.call(path_568456, query_568457, nil, nil, nil)

var firewallRulesGet* = Call_FirewallRulesGet_568446(name: "firewallRulesGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataLakeAnalytics/accounts/{accountName}/firewallRules/{firewallRuleName}",
    validator: validate_FirewallRulesGet_568447, base: "",
    url: url_FirewallRulesGet_568448, schemes: {Scheme.Https})
type
  Call_FirewallRulesUpdate_568484 = ref object of OpenApiRestCall_567666
proc url_FirewallRulesUpdate_568486(protocol: Scheme; host: string; base: string;
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
        value: "/providers/Microsoft.DataLakeAnalytics/accounts/"),
               (kind: VariableSegment, value: "accountName"),
               (kind: ConstantSegment, value: "/firewallRules/"),
               (kind: VariableSegment, value: "firewallRuleName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_FirewallRulesUpdate_568485(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Updates the specified firewall rule.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the Azure resource group.
  ##   subscriptionId: JString (required)
  ##                 : Get subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   firewallRuleName: JString (required)
  ##                   : The name of the firewall rule to update.
  ##   accountName: JString (required)
  ##              : The name of the Data Lake Analytics account.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568487 = path.getOrDefault("resourceGroupName")
  valid_568487 = validateParameter(valid_568487, JString, required = true,
                                 default = nil)
  if valid_568487 != nil:
    section.add "resourceGroupName", valid_568487
  var valid_568488 = path.getOrDefault("subscriptionId")
  valid_568488 = validateParameter(valid_568488, JString, required = true,
                                 default = nil)
  if valid_568488 != nil:
    section.add "subscriptionId", valid_568488
  var valid_568489 = path.getOrDefault("firewallRuleName")
  valid_568489 = validateParameter(valid_568489, JString, required = true,
                                 default = nil)
  if valid_568489 != nil:
    section.add "firewallRuleName", valid_568489
  var valid_568490 = path.getOrDefault("accountName")
  valid_568490 = validateParameter(valid_568490, JString, required = true,
                                 default = nil)
  if valid_568490 != nil:
    section.add "accountName", valid_568490
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568491 = query.getOrDefault("api-version")
  valid_568491 = validateParameter(valid_568491, JString, required = true,
                                 default = nil)
  if valid_568491 != nil:
    section.add "api-version", valid_568491
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject
  ##             : Parameters supplied to update the firewall rule.
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568493: Call_FirewallRulesUpdate_568484; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the specified firewall rule.
  ## 
  let valid = call_568493.validator(path, query, header, formData, body)
  let scheme = call_568493.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568493.url(scheme.get, call_568493.host, call_568493.base,
                         call_568493.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568493, url, valid)

proc call*(call_568494: Call_FirewallRulesUpdate_568484; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; firewallRuleName: string;
          accountName: string; parameters: JsonNode = nil): Recallable =
  ## firewallRulesUpdate
  ## Updates the specified firewall rule.
  ##   resourceGroupName: string (required)
  ##                    : The name of the Azure resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Get subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   parameters: JObject
  ##             : Parameters supplied to update the firewall rule.
  ##   firewallRuleName: string (required)
  ##                   : The name of the firewall rule to update.
  ##   accountName: string (required)
  ##              : The name of the Data Lake Analytics account.
  var path_568495 = newJObject()
  var query_568496 = newJObject()
  var body_568497 = newJObject()
  add(path_568495, "resourceGroupName", newJString(resourceGroupName))
  add(query_568496, "api-version", newJString(apiVersion))
  add(path_568495, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_568497 = parameters
  add(path_568495, "firewallRuleName", newJString(firewallRuleName))
  add(path_568495, "accountName", newJString(accountName))
  result = call_568494.call(path_568495, query_568496, nil, nil, body_568497)

var firewallRulesUpdate* = Call_FirewallRulesUpdate_568484(
    name: "firewallRulesUpdate", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataLakeAnalytics/accounts/{accountName}/firewallRules/{firewallRuleName}",
    validator: validate_FirewallRulesUpdate_568485, base: "",
    url: url_FirewallRulesUpdate_568486, schemes: {Scheme.Https})
type
  Call_FirewallRulesDelete_568472 = ref object of OpenApiRestCall_567666
proc url_FirewallRulesDelete_568474(protocol: Scheme; host: string; base: string;
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
        value: "/providers/Microsoft.DataLakeAnalytics/accounts/"),
               (kind: VariableSegment, value: "accountName"),
               (kind: ConstantSegment, value: "/firewallRules/"),
               (kind: VariableSegment, value: "firewallRuleName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_FirewallRulesDelete_568473(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Deletes the specified firewall rule from the specified Data Lake Analytics account
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the Azure resource group.
  ##   subscriptionId: JString (required)
  ##                 : Get subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   firewallRuleName: JString (required)
  ##                   : The name of the firewall rule to delete.
  ##   accountName: JString (required)
  ##              : The name of the Data Lake Analytics account.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568475 = path.getOrDefault("resourceGroupName")
  valid_568475 = validateParameter(valid_568475, JString, required = true,
                                 default = nil)
  if valid_568475 != nil:
    section.add "resourceGroupName", valid_568475
  var valid_568476 = path.getOrDefault("subscriptionId")
  valid_568476 = validateParameter(valid_568476, JString, required = true,
                                 default = nil)
  if valid_568476 != nil:
    section.add "subscriptionId", valid_568476
  var valid_568477 = path.getOrDefault("firewallRuleName")
  valid_568477 = validateParameter(valid_568477, JString, required = true,
                                 default = nil)
  if valid_568477 != nil:
    section.add "firewallRuleName", valid_568477
  var valid_568478 = path.getOrDefault("accountName")
  valid_568478 = validateParameter(valid_568478, JString, required = true,
                                 default = nil)
  if valid_568478 != nil:
    section.add "accountName", valid_568478
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568479 = query.getOrDefault("api-version")
  valid_568479 = validateParameter(valid_568479, JString, required = true,
                                 default = nil)
  if valid_568479 != nil:
    section.add "api-version", valid_568479
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568480: Call_FirewallRulesDelete_568472; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the specified firewall rule from the specified Data Lake Analytics account
  ## 
  let valid = call_568480.validator(path, query, header, formData, body)
  let scheme = call_568480.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568480.url(scheme.get, call_568480.host, call_568480.base,
                         call_568480.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568480, url, valid)

proc call*(call_568481: Call_FirewallRulesDelete_568472; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; firewallRuleName: string;
          accountName: string): Recallable =
  ## firewallRulesDelete
  ## Deletes the specified firewall rule from the specified Data Lake Analytics account
  ##   resourceGroupName: string (required)
  ##                    : The name of the Azure resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Get subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   firewallRuleName: string (required)
  ##                   : The name of the firewall rule to delete.
  ##   accountName: string (required)
  ##              : The name of the Data Lake Analytics account.
  var path_568482 = newJObject()
  var query_568483 = newJObject()
  add(path_568482, "resourceGroupName", newJString(resourceGroupName))
  add(query_568483, "api-version", newJString(apiVersion))
  add(path_568482, "subscriptionId", newJString(subscriptionId))
  add(path_568482, "firewallRuleName", newJString(firewallRuleName))
  add(path_568482, "accountName", newJString(accountName))
  result = call_568481.call(path_568482, query_568483, nil, nil, nil)

var firewallRulesDelete* = Call_FirewallRulesDelete_568472(
    name: "firewallRulesDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataLakeAnalytics/accounts/{accountName}/firewallRules/{firewallRuleName}",
    validator: validate_FirewallRulesDelete_568473, base: "",
    url: url_FirewallRulesDelete_568474, schemes: {Scheme.Https})
type
  Call_StorageAccountsListByAccount_568498 = ref object of OpenApiRestCall_567666
proc url_StorageAccountsListByAccount_568500(protocol: Scheme; host: string;
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
               (kind: ConstantSegment, value: "/storageAccounts")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_StorageAccountsListByAccount_568499(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the first page of Azure Storage accounts, if any, linked to the specified Data Lake Analytics account. The response includes a link to the next page, if any.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the Azure resource group.
  ##   subscriptionId: JString (required)
  ##                 : Get subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   accountName: JString (required)
  ##              : The name of the Data Lake Analytics account.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568501 = path.getOrDefault("resourceGroupName")
  valid_568501 = validateParameter(valid_568501, JString, required = true,
                                 default = nil)
  if valid_568501 != nil:
    section.add "resourceGroupName", valid_568501
  var valid_568502 = path.getOrDefault("subscriptionId")
  valid_568502 = validateParameter(valid_568502, JString, required = true,
                                 default = nil)
  if valid_568502 != nil:
    section.add "subscriptionId", valid_568502
  var valid_568503 = path.getOrDefault("accountName")
  valid_568503 = validateParameter(valid_568503, JString, required = true,
                                 default = nil)
  if valid_568503 != nil:
    section.add "accountName", valid_568503
  result.add "path", section
  ## parameters in `query` object:
  ##   $orderby: JString
  ##           : OrderBy clause. One or more comma-separated expressions with an optional "asc" (the default) or "desc" depending on the order you'd like the values sorted, e.g. Categories?$orderby=CategoryName desc. Optional.
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
  ##   $filter: JString
  ##          : The OData filter. Optional.
  section = newJObject()
  var valid_568504 = query.getOrDefault("$orderby")
  valid_568504 = validateParameter(valid_568504, JString, required = false,
                                 default = nil)
  if valid_568504 != nil:
    section.add "$orderby", valid_568504
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568505 = query.getOrDefault("api-version")
  valid_568505 = validateParameter(valid_568505, JString, required = true,
                                 default = nil)
  if valid_568505 != nil:
    section.add "api-version", valid_568505
  var valid_568506 = query.getOrDefault("$top")
  valid_568506 = validateParameter(valid_568506, JInt, required = false, default = nil)
  if valid_568506 != nil:
    section.add "$top", valid_568506
  var valid_568507 = query.getOrDefault("$select")
  valid_568507 = validateParameter(valid_568507, JString, required = false,
                                 default = nil)
  if valid_568507 != nil:
    section.add "$select", valid_568507
  var valid_568508 = query.getOrDefault("$skip")
  valid_568508 = validateParameter(valid_568508, JInt, required = false, default = nil)
  if valid_568508 != nil:
    section.add "$skip", valid_568508
  var valid_568509 = query.getOrDefault("$count")
  valid_568509 = validateParameter(valid_568509, JBool, required = false, default = nil)
  if valid_568509 != nil:
    section.add "$count", valid_568509
  var valid_568510 = query.getOrDefault("$filter")
  valid_568510 = validateParameter(valid_568510, JString, required = false,
                                 default = nil)
  if valid_568510 != nil:
    section.add "$filter", valid_568510
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568511: Call_StorageAccountsListByAccount_568498; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the first page of Azure Storage accounts, if any, linked to the specified Data Lake Analytics account. The response includes a link to the next page, if any.
  ## 
  let valid = call_568511.validator(path, query, header, formData, body)
  let scheme = call_568511.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568511.url(scheme.get, call_568511.host, call_568511.base,
                         call_568511.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568511, url, valid)

proc call*(call_568512: Call_StorageAccountsListByAccount_568498;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          accountName: string; Orderby: string = ""; Top: int = 0; Select: string = "";
          Skip: int = 0; Count: bool = false; Filter: string = ""): Recallable =
  ## storageAccountsListByAccount
  ## Gets the first page of Azure Storage accounts, if any, linked to the specified Data Lake Analytics account. The response includes a link to the next page, if any.
  ##   Orderby: string
  ##          : OrderBy clause. One or more comma-separated expressions with an optional "asc" (the default) or "desc" depending on the order you'd like the values sorted, e.g. Categories?$orderby=CategoryName desc. Optional.
  ##   resourceGroupName: string (required)
  ##                    : The name of the Azure resource group.
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
  ##   accountName: string (required)
  ##              : The name of the Data Lake Analytics account.
  ##   Filter: string
  ##         : The OData filter. Optional.
  var path_568513 = newJObject()
  var query_568514 = newJObject()
  add(query_568514, "$orderby", newJString(Orderby))
  add(path_568513, "resourceGroupName", newJString(resourceGroupName))
  add(query_568514, "api-version", newJString(apiVersion))
  add(path_568513, "subscriptionId", newJString(subscriptionId))
  add(query_568514, "$top", newJInt(Top))
  add(query_568514, "$select", newJString(Select))
  add(query_568514, "$skip", newJInt(Skip))
  add(query_568514, "$count", newJBool(Count))
  add(path_568513, "accountName", newJString(accountName))
  add(query_568514, "$filter", newJString(Filter))
  result = call_568512.call(path_568513, query_568514, nil, nil, nil)

var storageAccountsListByAccount* = Call_StorageAccountsListByAccount_568498(
    name: "storageAccountsListByAccount", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataLakeAnalytics/accounts/{accountName}/storageAccounts",
    validator: validate_StorageAccountsListByAccount_568499, base: "",
    url: url_StorageAccountsListByAccount_568500, schemes: {Scheme.Https})
type
  Call_StorageAccountsAdd_568527 = ref object of OpenApiRestCall_567666
proc url_StorageAccountsAdd_568529(protocol: Scheme; host: string; base: string;
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
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.DataLakeAnalytics/accounts/"),
               (kind: VariableSegment, value: "accountName"),
               (kind: ConstantSegment, value: "/storageAccounts/"),
               (kind: VariableSegment, value: "storageAccountName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_StorageAccountsAdd_568528(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Updates the specified Data Lake Analytics account to add an Azure Storage account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the Azure resource group.
  ##   storageAccountName: JString (required)
  ##                     : The name of the Azure Storage account to add
  ##   subscriptionId: JString (required)
  ##                 : Get subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   accountName: JString (required)
  ##              : The name of the Data Lake Analytics account.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568530 = path.getOrDefault("resourceGroupName")
  valid_568530 = validateParameter(valid_568530, JString, required = true,
                                 default = nil)
  if valid_568530 != nil:
    section.add "resourceGroupName", valid_568530
  var valid_568531 = path.getOrDefault("storageAccountName")
  valid_568531 = validateParameter(valid_568531, JString, required = true,
                                 default = nil)
  if valid_568531 != nil:
    section.add "storageAccountName", valid_568531
  var valid_568532 = path.getOrDefault("subscriptionId")
  valid_568532 = validateParameter(valid_568532, JString, required = true,
                                 default = nil)
  if valid_568532 != nil:
    section.add "subscriptionId", valid_568532
  var valid_568533 = path.getOrDefault("accountName")
  valid_568533 = validateParameter(valid_568533, JString, required = true,
                                 default = nil)
  if valid_568533 != nil:
    section.add "accountName", valid_568533
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568534 = query.getOrDefault("api-version")
  valid_568534 = validateParameter(valid_568534, JString, required = true,
                                 default = nil)
  if valid_568534 != nil:
    section.add "api-version", valid_568534
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

proc call*(call_568536: Call_StorageAccountsAdd_568527; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the specified Data Lake Analytics account to add an Azure Storage account.
  ## 
  let valid = call_568536.validator(path, query, header, formData, body)
  let scheme = call_568536.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568536.url(scheme.get, call_568536.host, call_568536.base,
                         call_568536.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568536, url, valid)

proc call*(call_568537: Call_StorageAccountsAdd_568527; resourceGroupName: string;
          apiVersion: string; storageAccountName: string; subscriptionId: string;
          parameters: JsonNode; accountName: string): Recallable =
  ## storageAccountsAdd
  ## Updates the specified Data Lake Analytics account to add an Azure Storage account.
  ##   resourceGroupName: string (required)
  ##                    : The name of the Azure resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   storageAccountName: string (required)
  ##                     : The name of the Azure Storage account to add
  ##   subscriptionId: string (required)
  ##                 : Get subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   parameters: JObject (required)
  ##             : The parameters containing the access key and optional suffix for the Azure Storage Account.
  ##   accountName: string (required)
  ##              : The name of the Data Lake Analytics account.
  var path_568538 = newJObject()
  var query_568539 = newJObject()
  var body_568540 = newJObject()
  add(path_568538, "resourceGroupName", newJString(resourceGroupName))
  add(query_568539, "api-version", newJString(apiVersion))
  add(path_568538, "storageAccountName", newJString(storageAccountName))
  add(path_568538, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_568540 = parameters
  add(path_568538, "accountName", newJString(accountName))
  result = call_568537.call(path_568538, query_568539, nil, nil, body_568540)

var storageAccountsAdd* = Call_StorageAccountsAdd_568527(
    name: "storageAccountsAdd", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataLakeAnalytics/accounts/{accountName}/storageAccounts/{storageAccountName}",
    validator: validate_StorageAccountsAdd_568528, base: "",
    url: url_StorageAccountsAdd_568529, schemes: {Scheme.Https})
type
  Call_StorageAccountsGet_568515 = ref object of OpenApiRestCall_567666
proc url_StorageAccountsGet_568517(protocol: Scheme; host: string; base: string;
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
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.DataLakeAnalytics/accounts/"),
               (kind: VariableSegment, value: "accountName"),
               (kind: ConstantSegment, value: "/storageAccounts/"),
               (kind: VariableSegment, value: "storageAccountName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_StorageAccountsGet_568516(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Gets the specified Azure Storage account linked to the given Data Lake Analytics account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the Azure resource group.
  ##   storageAccountName: JString (required)
  ##                     : The name of the Azure Storage account for which to retrieve the details.
  ##   subscriptionId: JString (required)
  ##                 : Get subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   accountName: JString (required)
  ##              : The name of the Data Lake Analytics account.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568518 = path.getOrDefault("resourceGroupName")
  valid_568518 = validateParameter(valid_568518, JString, required = true,
                                 default = nil)
  if valid_568518 != nil:
    section.add "resourceGroupName", valid_568518
  var valid_568519 = path.getOrDefault("storageAccountName")
  valid_568519 = validateParameter(valid_568519, JString, required = true,
                                 default = nil)
  if valid_568519 != nil:
    section.add "storageAccountName", valid_568519
  var valid_568520 = path.getOrDefault("subscriptionId")
  valid_568520 = validateParameter(valid_568520, JString, required = true,
                                 default = nil)
  if valid_568520 != nil:
    section.add "subscriptionId", valid_568520
  var valid_568521 = path.getOrDefault("accountName")
  valid_568521 = validateParameter(valid_568521, JString, required = true,
                                 default = nil)
  if valid_568521 != nil:
    section.add "accountName", valid_568521
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568522 = query.getOrDefault("api-version")
  valid_568522 = validateParameter(valid_568522, JString, required = true,
                                 default = nil)
  if valid_568522 != nil:
    section.add "api-version", valid_568522
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568523: Call_StorageAccountsGet_568515; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the specified Azure Storage account linked to the given Data Lake Analytics account.
  ## 
  let valid = call_568523.validator(path, query, header, formData, body)
  let scheme = call_568523.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568523.url(scheme.get, call_568523.host, call_568523.base,
                         call_568523.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568523, url, valid)

proc call*(call_568524: Call_StorageAccountsGet_568515; resourceGroupName: string;
          apiVersion: string; storageAccountName: string; subscriptionId: string;
          accountName: string): Recallable =
  ## storageAccountsGet
  ## Gets the specified Azure Storage account linked to the given Data Lake Analytics account.
  ##   resourceGroupName: string (required)
  ##                    : The name of the Azure resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   storageAccountName: string (required)
  ##                     : The name of the Azure Storage account for which to retrieve the details.
  ##   subscriptionId: string (required)
  ##                 : Get subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   accountName: string (required)
  ##              : The name of the Data Lake Analytics account.
  var path_568525 = newJObject()
  var query_568526 = newJObject()
  add(path_568525, "resourceGroupName", newJString(resourceGroupName))
  add(query_568526, "api-version", newJString(apiVersion))
  add(path_568525, "storageAccountName", newJString(storageAccountName))
  add(path_568525, "subscriptionId", newJString(subscriptionId))
  add(path_568525, "accountName", newJString(accountName))
  result = call_568524.call(path_568525, query_568526, nil, nil, nil)

var storageAccountsGet* = Call_StorageAccountsGet_568515(
    name: "storageAccountsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataLakeAnalytics/accounts/{accountName}/storageAccounts/{storageAccountName}",
    validator: validate_StorageAccountsGet_568516, base: "",
    url: url_StorageAccountsGet_568517, schemes: {Scheme.Https})
type
  Call_StorageAccountsUpdate_568553 = ref object of OpenApiRestCall_567666
proc url_StorageAccountsUpdate_568555(protocol: Scheme; host: string; base: string;
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
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.DataLakeAnalytics/accounts/"),
               (kind: VariableSegment, value: "accountName"),
               (kind: ConstantSegment, value: "/storageAccounts/"),
               (kind: VariableSegment, value: "storageAccountName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_StorageAccountsUpdate_568554(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates the Data Lake Analytics account to replace Azure Storage blob account details, such as the access key and/or suffix.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the Azure resource group.
  ##   storageAccountName: JString (required)
  ##                     : The Azure Storage account to modify
  ##   subscriptionId: JString (required)
  ##                 : Get subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   accountName: JString (required)
  ##              : The name of the Data Lake Analytics account.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568556 = path.getOrDefault("resourceGroupName")
  valid_568556 = validateParameter(valid_568556, JString, required = true,
                                 default = nil)
  if valid_568556 != nil:
    section.add "resourceGroupName", valid_568556
  var valid_568557 = path.getOrDefault("storageAccountName")
  valid_568557 = validateParameter(valid_568557, JString, required = true,
                                 default = nil)
  if valid_568557 != nil:
    section.add "storageAccountName", valid_568557
  var valid_568558 = path.getOrDefault("subscriptionId")
  valid_568558 = validateParameter(valid_568558, JString, required = true,
                                 default = nil)
  if valid_568558 != nil:
    section.add "subscriptionId", valid_568558
  var valid_568559 = path.getOrDefault("accountName")
  valid_568559 = validateParameter(valid_568559, JString, required = true,
                                 default = nil)
  if valid_568559 != nil:
    section.add "accountName", valid_568559
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568560 = query.getOrDefault("api-version")
  valid_568560 = validateParameter(valid_568560, JString, required = true,
                                 default = nil)
  if valid_568560 != nil:
    section.add "api-version", valid_568560
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject
  ##             : The parameters containing the access key and suffix to update the storage account with, if any. Passing nothing results in no change.
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568562: Call_StorageAccountsUpdate_568553; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the Data Lake Analytics account to replace Azure Storage blob account details, such as the access key and/or suffix.
  ## 
  let valid = call_568562.validator(path, query, header, formData, body)
  let scheme = call_568562.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568562.url(scheme.get, call_568562.host, call_568562.base,
                         call_568562.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568562, url, valid)

proc call*(call_568563: Call_StorageAccountsUpdate_568553;
          resourceGroupName: string; apiVersion: string; storageAccountName: string;
          subscriptionId: string; accountName: string; parameters: JsonNode = nil): Recallable =
  ## storageAccountsUpdate
  ## Updates the Data Lake Analytics account to replace Azure Storage blob account details, such as the access key and/or suffix.
  ##   resourceGroupName: string (required)
  ##                    : The name of the Azure resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   storageAccountName: string (required)
  ##                     : The Azure Storage account to modify
  ##   subscriptionId: string (required)
  ##                 : Get subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   parameters: JObject
  ##             : The parameters containing the access key and suffix to update the storage account with, if any. Passing nothing results in no change.
  ##   accountName: string (required)
  ##              : The name of the Data Lake Analytics account.
  var path_568564 = newJObject()
  var query_568565 = newJObject()
  var body_568566 = newJObject()
  add(path_568564, "resourceGroupName", newJString(resourceGroupName))
  add(query_568565, "api-version", newJString(apiVersion))
  add(path_568564, "storageAccountName", newJString(storageAccountName))
  add(path_568564, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_568566 = parameters
  add(path_568564, "accountName", newJString(accountName))
  result = call_568563.call(path_568564, query_568565, nil, nil, body_568566)

var storageAccountsUpdate* = Call_StorageAccountsUpdate_568553(
    name: "storageAccountsUpdate", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataLakeAnalytics/accounts/{accountName}/storageAccounts/{storageAccountName}",
    validator: validate_StorageAccountsUpdate_568554, base: "",
    url: url_StorageAccountsUpdate_568555, schemes: {Scheme.Https})
type
  Call_StorageAccountsDelete_568541 = ref object of OpenApiRestCall_567666
proc url_StorageAccountsDelete_568543(protocol: Scheme; host: string; base: string;
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
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.DataLakeAnalytics/accounts/"),
               (kind: VariableSegment, value: "accountName"),
               (kind: ConstantSegment, value: "/storageAccounts/"),
               (kind: VariableSegment, value: "storageAccountName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_StorageAccountsDelete_568542(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates the specified Data Lake Analytics account to remove an Azure Storage account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the Azure resource group.
  ##   storageAccountName: JString (required)
  ##                     : The name of the Azure Storage account to remove
  ##   subscriptionId: JString (required)
  ##                 : Get subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   accountName: JString (required)
  ##              : The name of the Data Lake Analytics account.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568544 = path.getOrDefault("resourceGroupName")
  valid_568544 = validateParameter(valid_568544, JString, required = true,
                                 default = nil)
  if valid_568544 != nil:
    section.add "resourceGroupName", valid_568544
  var valid_568545 = path.getOrDefault("storageAccountName")
  valid_568545 = validateParameter(valid_568545, JString, required = true,
                                 default = nil)
  if valid_568545 != nil:
    section.add "storageAccountName", valid_568545
  var valid_568546 = path.getOrDefault("subscriptionId")
  valid_568546 = validateParameter(valid_568546, JString, required = true,
                                 default = nil)
  if valid_568546 != nil:
    section.add "subscriptionId", valid_568546
  var valid_568547 = path.getOrDefault("accountName")
  valid_568547 = validateParameter(valid_568547, JString, required = true,
                                 default = nil)
  if valid_568547 != nil:
    section.add "accountName", valid_568547
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568548 = query.getOrDefault("api-version")
  valid_568548 = validateParameter(valid_568548, JString, required = true,
                                 default = nil)
  if valid_568548 != nil:
    section.add "api-version", valid_568548
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568549: Call_StorageAccountsDelete_568541; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the specified Data Lake Analytics account to remove an Azure Storage account.
  ## 
  let valid = call_568549.validator(path, query, header, formData, body)
  let scheme = call_568549.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568549.url(scheme.get, call_568549.host, call_568549.base,
                         call_568549.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568549, url, valid)

proc call*(call_568550: Call_StorageAccountsDelete_568541;
          resourceGroupName: string; apiVersion: string; storageAccountName: string;
          subscriptionId: string; accountName: string): Recallable =
  ## storageAccountsDelete
  ## Updates the specified Data Lake Analytics account to remove an Azure Storage account.
  ##   resourceGroupName: string (required)
  ##                    : The name of the Azure resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   storageAccountName: string (required)
  ##                     : The name of the Azure Storage account to remove
  ##   subscriptionId: string (required)
  ##                 : Get subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   accountName: string (required)
  ##              : The name of the Data Lake Analytics account.
  var path_568551 = newJObject()
  var query_568552 = newJObject()
  add(path_568551, "resourceGroupName", newJString(resourceGroupName))
  add(query_568552, "api-version", newJString(apiVersion))
  add(path_568551, "storageAccountName", newJString(storageAccountName))
  add(path_568551, "subscriptionId", newJString(subscriptionId))
  add(path_568551, "accountName", newJString(accountName))
  result = call_568550.call(path_568551, query_568552, nil, nil, nil)

var storageAccountsDelete* = Call_StorageAccountsDelete_568541(
    name: "storageAccountsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataLakeAnalytics/accounts/{accountName}/storageAccounts/{storageAccountName}",
    validator: validate_StorageAccountsDelete_568542, base: "",
    url: url_StorageAccountsDelete_568543, schemes: {Scheme.Https})
type
  Call_StorageAccountsListStorageContainers_568567 = ref object of OpenApiRestCall_567666
proc url_StorageAccountsListStorageContainers_568569(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
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
               (kind: ConstantSegment, value: "/storageAccounts/"),
               (kind: VariableSegment, value: "storageAccountName"),
               (kind: ConstantSegment, value: "/containers")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_StorageAccountsListStorageContainers_568568(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists the Azure Storage containers, if any, associated with the specified Data Lake Analytics and Azure Storage account combination. The response includes a link to the next page of results, if any.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the Azure resource group.
  ##   storageAccountName: JString (required)
  ##                     : The name of the Azure storage account from which to list blob containers.
  ##   subscriptionId: JString (required)
  ##                 : Get subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   accountName: JString (required)
  ##              : The name of the Data Lake Analytics account.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568570 = path.getOrDefault("resourceGroupName")
  valid_568570 = validateParameter(valid_568570, JString, required = true,
                                 default = nil)
  if valid_568570 != nil:
    section.add "resourceGroupName", valid_568570
  var valid_568571 = path.getOrDefault("storageAccountName")
  valid_568571 = validateParameter(valid_568571, JString, required = true,
                                 default = nil)
  if valid_568571 != nil:
    section.add "storageAccountName", valid_568571
  var valid_568572 = path.getOrDefault("subscriptionId")
  valid_568572 = validateParameter(valid_568572, JString, required = true,
                                 default = nil)
  if valid_568572 != nil:
    section.add "subscriptionId", valid_568572
  var valid_568573 = path.getOrDefault("accountName")
  valid_568573 = validateParameter(valid_568573, JString, required = true,
                                 default = nil)
  if valid_568573 != nil:
    section.add "accountName", valid_568573
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568574 = query.getOrDefault("api-version")
  valid_568574 = validateParameter(valid_568574, JString, required = true,
                                 default = nil)
  if valid_568574 != nil:
    section.add "api-version", valid_568574
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568575: Call_StorageAccountsListStorageContainers_568567;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the Azure Storage containers, if any, associated with the specified Data Lake Analytics and Azure Storage account combination. The response includes a link to the next page of results, if any.
  ## 
  let valid = call_568575.validator(path, query, header, formData, body)
  let scheme = call_568575.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568575.url(scheme.get, call_568575.host, call_568575.base,
                         call_568575.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568575, url, valid)

proc call*(call_568576: Call_StorageAccountsListStorageContainers_568567;
          resourceGroupName: string; apiVersion: string; storageAccountName: string;
          subscriptionId: string; accountName: string): Recallable =
  ## storageAccountsListStorageContainers
  ## Lists the Azure Storage containers, if any, associated with the specified Data Lake Analytics and Azure Storage account combination. The response includes a link to the next page of results, if any.
  ##   resourceGroupName: string (required)
  ##                    : The name of the Azure resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   storageAccountName: string (required)
  ##                     : The name of the Azure storage account from which to list blob containers.
  ##   subscriptionId: string (required)
  ##                 : Get subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   accountName: string (required)
  ##              : The name of the Data Lake Analytics account.
  var path_568577 = newJObject()
  var query_568578 = newJObject()
  add(path_568577, "resourceGroupName", newJString(resourceGroupName))
  add(query_568578, "api-version", newJString(apiVersion))
  add(path_568577, "storageAccountName", newJString(storageAccountName))
  add(path_568577, "subscriptionId", newJString(subscriptionId))
  add(path_568577, "accountName", newJString(accountName))
  result = call_568576.call(path_568577, query_568578, nil, nil, nil)

var storageAccountsListStorageContainers* = Call_StorageAccountsListStorageContainers_568567(
    name: "storageAccountsListStorageContainers", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataLakeAnalytics/accounts/{accountName}/storageAccounts/{storageAccountName}/containers",
    validator: validate_StorageAccountsListStorageContainers_568568, base: "",
    url: url_StorageAccountsListStorageContainers_568569, schemes: {Scheme.Https})
type
  Call_StorageAccountsGetStorageContainer_568579 = ref object of OpenApiRestCall_567666
proc url_StorageAccountsGetStorageContainer_568581(protocol: Scheme; host: string;
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
               (kind: ConstantSegment, value: "/storageAccounts/"),
               (kind: VariableSegment, value: "storageAccountName"),
               (kind: ConstantSegment, value: "/containers/"),
               (kind: VariableSegment, value: "containerName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_StorageAccountsGetStorageContainer_568580(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the specified Azure Storage container associated with the given Data Lake Analytics and Azure Storage accounts.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the Azure resource group.
  ##   containerName: JString (required)
  ##                : The name of the Azure storage container to retrieve
  ##   storageAccountName: JString (required)
  ##                     : The name of the Azure storage account from which to retrieve the blob container.
  ##   subscriptionId: JString (required)
  ##                 : Get subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   accountName: JString (required)
  ##              : The name of the Data Lake Analytics account.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568582 = path.getOrDefault("resourceGroupName")
  valid_568582 = validateParameter(valid_568582, JString, required = true,
                                 default = nil)
  if valid_568582 != nil:
    section.add "resourceGroupName", valid_568582
  var valid_568583 = path.getOrDefault("containerName")
  valid_568583 = validateParameter(valid_568583, JString, required = true,
                                 default = nil)
  if valid_568583 != nil:
    section.add "containerName", valid_568583
  var valid_568584 = path.getOrDefault("storageAccountName")
  valid_568584 = validateParameter(valid_568584, JString, required = true,
                                 default = nil)
  if valid_568584 != nil:
    section.add "storageAccountName", valid_568584
  var valid_568585 = path.getOrDefault("subscriptionId")
  valid_568585 = validateParameter(valid_568585, JString, required = true,
                                 default = nil)
  if valid_568585 != nil:
    section.add "subscriptionId", valid_568585
  var valid_568586 = path.getOrDefault("accountName")
  valid_568586 = validateParameter(valid_568586, JString, required = true,
                                 default = nil)
  if valid_568586 != nil:
    section.add "accountName", valid_568586
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568587 = query.getOrDefault("api-version")
  valid_568587 = validateParameter(valid_568587, JString, required = true,
                                 default = nil)
  if valid_568587 != nil:
    section.add "api-version", valid_568587
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568588: Call_StorageAccountsGetStorageContainer_568579;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the specified Azure Storage container associated with the given Data Lake Analytics and Azure Storage accounts.
  ## 
  let valid = call_568588.validator(path, query, header, formData, body)
  let scheme = call_568588.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568588.url(scheme.get, call_568588.host, call_568588.base,
                         call_568588.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568588, url, valid)

proc call*(call_568589: Call_StorageAccountsGetStorageContainer_568579;
          resourceGroupName: string; apiVersion: string; containerName: string;
          storageAccountName: string; subscriptionId: string; accountName: string): Recallable =
  ## storageAccountsGetStorageContainer
  ## Gets the specified Azure Storage container associated with the given Data Lake Analytics and Azure Storage accounts.
  ##   resourceGroupName: string (required)
  ##                    : The name of the Azure resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   containerName: string (required)
  ##                : The name of the Azure storage container to retrieve
  ##   storageAccountName: string (required)
  ##                     : The name of the Azure storage account from which to retrieve the blob container.
  ##   subscriptionId: string (required)
  ##                 : Get subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   accountName: string (required)
  ##              : The name of the Data Lake Analytics account.
  var path_568590 = newJObject()
  var query_568591 = newJObject()
  add(path_568590, "resourceGroupName", newJString(resourceGroupName))
  add(query_568591, "api-version", newJString(apiVersion))
  add(path_568590, "containerName", newJString(containerName))
  add(path_568590, "storageAccountName", newJString(storageAccountName))
  add(path_568590, "subscriptionId", newJString(subscriptionId))
  add(path_568590, "accountName", newJString(accountName))
  result = call_568589.call(path_568590, query_568591, nil, nil, nil)

var storageAccountsGetStorageContainer* = Call_StorageAccountsGetStorageContainer_568579(
    name: "storageAccountsGetStorageContainer", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataLakeAnalytics/accounts/{accountName}/storageAccounts/{storageAccountName}/containers/{containerName}",
    validator: validate_StorageAccountsGetStorageContainer_568580, base: "",
    url: url_StorageAccountsGetStorageContainer_568581, schemes: {Scheme.Https})
type
  Call_StorageAccountsListSasTokens_568592 = ref object of OpenApiRestCall_567666
proc url_StorageAccountsListSasTokens_568594(protocol: Scheme; host: string;
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
               (kind: ConstantSegment, value: "/storageAccounts/"),
               (kind: VariableSegment, value: "storageAccountName"),
               (kind: ConstantSegment, value: "/containers/"),
               (kind: VariableSegment, value: "containerName"),
               (kind: ConstantSegment, value: "/listSasTokens")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_StorageAccountsListSasTokens_568593(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the SAS token associated with the specified Data Lake Analytics and Azure Storage account and container combination.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the Azure resource group.
  ##   containerName: JString (required)
  ##                : The name of the Azure storage container for which the SAS token is being requested.
  ##   storageAccountName: JString (required)
  ##                     : The name of the Azure storage account for which the SAS token is being requested.
  ##   subscriptionId: JString (required)
  ##                 : Get subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   accountName: JString (required)
  ##              : The name of the Data Lake Analytics account.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568595 = path.getOrDefault("resourceGroupName")
  valid_568595 = validateParameter(valid_568595, JString, required = true,
                                 default = nil)
  if valid_568595 != nil:
    section.add "resourceGroupName", valid_568595
  var valid_568596 = path.getOrDefault("containerName")
  valid_568596 = validateParameter(valid_568596, JString, required = true,
                                 default = nil)
  if valid_568596 != nil:
    section.add "containerName", valid_568596
  var valid_568597 = path.getOrDefault("storageAccountName")
  valid_568597 = validateParameter(valid_568597, JString, required = true,
                                 default = nil)
  if valid_568597 != nil:
    section.add "storageAccountName", valid_568597
  var valid_568598 = path.getOrDefault("subscriptionId")
  valid_568598 = validateParameter(valid_568598, JString, required = true,
                                 default = nil)
  if valid_568598 != nil:
    section.add "subscriptionId", valid_568598
  var valid_568599 = path.getOrDefault("accountName")
  valid_568599 = validateParameter(valid_568599, JString, required = true,
                                 default = nil)
  if valid_568599 != nil:
    section.add "accountName", valid_568599
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568600 = query.getOrDefault("api-version")
  valid_568600 = validateParameter(valid_568600, JString, required = true,
                                 default = nil)
  if valid_568600 != nil:
    section.add "api-version", valid_568600
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568601: Call_StorageAccountsListSasTokens_568592; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the SAS token associated with the specified Data Lake Analytics and Azure Storage account and container combination.
  ## 
  let valid = call_568601.validator(path, query, header, formData, body)
  let scheme = call_568601.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568601.url(scheme.get, call_568601.host, call_568601.base,
                         call_568601.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568601, url, valid)

proc call*(call_568602: Call_StorageAccountsListSasTokens_568592;
          resourceGroupName: string; apiVersion: string; containerName: string;
          storageAccountName: string; subscriptionId: string; accountName: string): Recallable =
  ## storageAccountsListSasTokens
  ## Gets the SAS token associated with the specified Data Lake Analytics and Azure Storage account and container combination.
  ##   resourceGroupName: string (required)
  ##                    : The name of the Azure resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   containerName: string (required)
  ##                : The name of the Azure storage container for which the SAS token is being requested.
  ##   storageAccountName: string (required)
  ##                     : The name of the Azure storage account for which the SAS token is being requested.
  ##   subscriptionId: string (required)
  ##                 : Get subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   accountName: string (required)
  ##              : The name of the Data Lake Analytics account.
  var path_568603 = newJObject()
  var query_568604 = newJObject()
  add(path_568603, "resourceGroupName", newJString(resourceGroupName))
  add(query_568604, "api-version", newJString(apiVersion))
  add(path_568603, "containerName", newJString(containerName))
  add(path_568603, "storageAccountName", newJString(storageAccountName))
  add(path_568603, "subscriptionId", newJString(subscriptionId))
  add(path_568603, "accountName", newJString(accountName))
  result = call_568602.call(path_568603, query_568604, nil, nil, nil)

var storageAccountsListSasTokens* = Call_StorageAccountsListSasTokens_568592(
    name: "storageAccountsListSasTokens", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataLakeAnalytics/accounts/{accountName}/storageAccounts/{storageAccountName}/containers/{containerName}/listSasTokens",
    validator: validate_StorageAccountsListSasTokens_568593, base: "",
    url: url_StorageAccountsListSasTokens_568594, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)

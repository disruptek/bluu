
import
  json, options, hashes, uri, rest, os, uri, httpcore

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

  OpenApiRestCall_563564 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_563564](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_563564): Option[Scheme] {.used.} =
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
  Call_OperationsList_563786 = ref object of OpenApiRestCall_563564
proc url_OperationsList_563788(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_OperationsList_563787(path: JsonNode; query: JsonNode;
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
  var valid_563949 = query.getOrDefault("api-version")
  valid_563949 = validateParameter(valid_563949, JString, required = true,
                                 default = nil)
  if valid_563949 != nil:
    section.add "api-version", valid_563949
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_563972: Call_OperationsList_563786; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all of the available Data Lake Analytics REST API operations.
  ## 
  let valid = call_563972.validator(path, query, header, formData, body)
  let scheme = call_563972.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_563972.url(scheme.get, call_563972.host, call_563972.base,
                         call_563972.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_563972, url, valid)

proc call*(call_564043: Call_OperationsList_563786; apiVersion: string): Recallable =
  ## operationsList
  ## Lists all of the available Data Lake Analytics REST API operations.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  var query_564044 = newJObject()
  add(query_564044, "api-version", newJString(apiVersion))
  result = call_564043.call(nil, query_564044, nil, nil, nil)

var operationsList* = Call_OperationsList_563786(name: "operationsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com",
    route: "/providers/Microsoft.DataLakeAnalytics/operations",
    validator: validate_OperationsList_563787, base: "", url: url_OperationsList_563788,
    schemes: {Scheme.Https})
type
  Call_AccountsList_564084 = ref object of OpenApiRestCall_563564
proc url_AccountsList_564086(protocol: Scheme; host: string; base: string;
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

proc validate_AccountsList_564085(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_564102 = path.getOrDefault("subscriptionId")
  valid_564102 = validateParameter(valid_564102, JString, required = true,
                                 default = nil)
  if valid_564102 != nil:
    section.add "subscriptionId", valid_564102
  result.add "path", section
  ## parameters in `query` object:
  ##   $top: JInt
  ##       : The number of items to return. Optional.
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   $select: JString
  ##          : OData Select statement. Limits the properties on each entry to just those requested, e.g. Categories?$select=CategoryName,Description. Optional.
  ##   $count: JBool
  ##         : The Boolean value of true or false to request a count of the matching resources included with the resources in the response, e.g. Categories?$count=true. Optional.
  ##   $orderby: JString
  ##           : OrderBy clause. One or more comma-separated expressions with an optional "asc" (the default) or "desc" depending on the order you'd like the values sorted, e.g. Categories?$orderby=CategoryName desc. Optional.
  ##   $skip: JInt
  ##        : The number of items to skip over before returning elements. Optional.
  ##   $filter: JString
  ##          : OData filter. Optional.
  section = newJObject()
  var valid_564103 = query.getOrDefault("$top")
  valid_564103 = validateParameter(valid_564103, JInt, required = false, default = nil)
  if valid_564103 != nil:
    section.add "$top", valid_564103
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564104 = query.getOrDefault("api-version")
  valid_564104 = validateParameter(valid_564104, JString, required = true,
                                 default = nil)
  if valid_564104 != nil:
    section.add "api-version", valid_564104
  var valid_564105 = query.getOrDefault("$select")
  valid_564105 = validateParameter(valid_564105, JString, required = false,
                                 default = nil)
  if valid_564105 != nil:
    section.add "$select", valid_564105
  var valid_564106 = query.getOrDefault("$count")
  valid_564106 = validateParameter(valid_564106, JBool, required = false, default = nil)
  if valid_564106 != nil:
    section.add "$count", valid_564106
  var valid_564107 = query.getOrDefault("$orderby")
  valid_564107 = validateParameter(valid_564107, JString, required = false,
                                 default = nil)
  if valid_564107 != nil:
    section.add "$orderby", valid_564107
  var valid_564108 = query.getOrDefault("$skip")
  valid_564108 = validateParameter(valid_564108, JInt, required = false, default = nil)
  if valid_564108 != nil:
    section.add "$skip", valid_564108
  var valid_564109 = query.getOrDefault("$filter")
  valid_564109 = validateParameter(valid_564109, JString, required = false,
                                 default = nil)
  if valid_564109 != nil:
    section.add "$filter", valid_564109
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564110: Call_AccountsList_564084; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the first page of Data Lake Analytics accounts, if any, within the current subscription. This includes a link to the next page, if any.
  ## 
  let valid = call_564110.validator(path, query, header, formData, body)
  let scheme = call_564110.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564110.url(scheme.get, call_564110.host, call_564110.base,
                         call_564110.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564110, url, valid)

proc call*(call_564111: Call_AccountsList_564084; apiVersion: string;
          subscriptionId: string; Top: int = 0; Select: string = ""; Count: bool = false;
          Orderby: string = ""; Skip: int = 0; Filter: string = ""): Recallable =
  ## accountsList
  ## Gets the first page of Data Lake Analytics accounts, if any, within the current subscription. This includes a link to the next page, if any.
  ##   Top: int
  ##      : The number of items to return. Optional.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   Select: string
  ##         : OData Select statement. Limits the properties on each entry to just those requested, e.g. Categories?$select=CategoryName,Description. Optional.
  ##   Count: bool
  ##        : The Boolean value of true or false to request a count of the matching resources included with the resources in the response, e.g. Categories?$count=true. Optional.
  ##   subscriptionId: string (required)
  ##                 : Get subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   Orderby: string
  ##          : OrderBy clause. One or more comma-separated expressions with an optional "asc" (the default) or "desc" depending on the order you'd like the values sorted, e.g. Categories?$orderby=CategoryName desc. Optional.
  ##   Skip: int
  ##       : The number of items to skip over before returning elements. Optional.
  ##   Filter: string
  ##         : OData filter. Optional.
  var path_564112 = newJObject()
  var query_564113 = newJObject()
  add(query_564113, "$top", newJInt(Top))
  add(query_564113, "api-version", newJString(apiVersion))
  add(query_564113, "$select", newJString(Select))
  add(query_564113, "$count", newJBool(Count))
  add(path_564112, "subscriptionId", newJString(subscriptionId))
  add(query_564113, "$orderby", newJString(Orderby))
  add(query_564113, "$skip", newJInt(Skip))
  add(query_564113, "$filter", newJString(Filter))
  result = call_564111.call(path_564112, query_564113, nil, nil, nil)

var accountsList* = Call_AccountsList_564084(name: "accountsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.DataLakeAnalytics/accounts",
    validator: validate_AccountsList_564085, base: "", url: url_AccountsList_564086,
    schemes: {Scheme.Https})
type
  Call_LocationsGetCapability_564114 = ref object of OpenApiRestCall_563564
proc url_LocationsGetCapability_564116(protocol: Scheme; host: string; base: string;
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

proc validate_LocationsGetCapability_564115(path: JsonNode; query: JsonNode;
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
  var valid_564117 = path.getOrDefault("subscriptionId")
  valid_564117 = validateParameter(valid_564117, JString, required = true,
                                 default = nil)
  if valid_564117 != nil:
    section.add "subscriptionId", valid_564117
  var valid_564118 = path.getOrDefault("location")
  valid_564118 = validateParameter(valid_564118, JString, required = true,
                                 default = nil)
  if valid_564118 != nil:
    section.add "location", valid_564118
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564119 = query.getOrDefault("api-version")
  valid_564119 = validateParameter(valid_564119, JString, required = true,
                                 default = nil)
  if valid_564119 != nil:
    section.add "api-version", valid_564119
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564120: Call_LocationsGetCapability_564114; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets subscription-level properties and limits for Data Lake Analytics specified by resource location.
  ## 
  let valid = call_564120.validator(path, query, header, formData, body)
  let scheme = call_564120.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564120.url(scheme.get, call_564120.host, call_564120.base,
                         call_564120.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564120, url, valid)

proc call*(call_564121: Call_LocationsGetCapability_564114; apiVersion: string;
          subscriptionId: string; location: string): Recallable =
  ## locationsGetCapability
  ## Gets subscription-level properties and limits for Data Lake Analytics specified by resource location.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Get subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   location: string (required)
  ##           : The resource location without whitespace.
  var path_564122 = newJObject()
  var query_564123 = newJObject()
  add(query_564123, "api-version", newJString(apiVersion))
  add(path_564122, "subscriptionId", newJString(subscriptionId))
  add(path_564122, "location", newJString(location))
  result = call_564121.call(path_564122, query_564123, nil, nil, nil)

var locationsGetCapability* = Call_LocationsGetCapability_564114(
    name: "locationsGetCapability", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.DataLakeAnalytics/locations/{location}/capability",
    validator: validate_LocationsGetCapability_564115, base: "",
    url: url_LocationsGetCapability_564116, schemes: {Scheme.Https})
type
  Call_AccountsCheckNameAvailability_564124 = ref object of OpenApiRestCall_563564
proc url_AccountsCheckNameAvailability_564126(protocol: Scheme; host: string;
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

proc validate_AccountsCheckNameAvailability_564125(path: JsonNode; query: JsonNode;
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
  var valid_564144 = path.getOrDefault("subscriptionId")
  valid_564144 = validateParameter(valid_564144, JString, required = true,
                                 default = nil)
  if valid_564144 != nil:
    section.add "subscriptionId", valid_564144
  var valid_564145 = path.getOrDefault("location")
  valid_564145 = validateParameter(valid_564145, JString, required = true,
                                 default = nil)
  if valid_564145 != nil:
    section.add "location", valid_564145
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564146 = query.getOrDefault("api-version")
  valid_564146 = validateParameter(valid_564146, JString, required = true,
                                 default = nil)
  if valid_564146 != nil:
    section.add "api-version", valid_564146
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

proc call*(call_564148: Call_AccountsCheckNameAvailability_564124; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Checks whether the specified account name is available or taken.
  ## 
  let valid = call_564148.validator(path, query, header, formData, body)
  let scheme = call_564148.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564148.url(scheme.get, call_564148.host, call_564148.base,
                         call_564148.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564148, url, valid)

proc call*(call_564149: Call_AccountsCheckNameAvailability_564124;
          apiVersion: string; subscriptionId: string; location: string;
          parameters: JsonNode): Recallable =
  ## accountsCheckNameAvailability
  ## Checks whether the specified account name is available or taken.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Get subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   location: string (required)
  ##           : The resource location without whitespace.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to check the Data Lake Analytics account name availability.
  var path_564150 = newJObject()
  var query_564151 = newJObject()
  var body_564152 = newJObject()
  add(query_564151, "api-version", newJString(apiVersion))
  add(path_564150, "subscriptionId", newJString(subscriptionId))
  add(path_564150, "location", newJString(location))
  if parameters != nil:
    body_564152 = parameters
  result = call_564149.call(path_564150, query_564151, nil, nil, body_564152)

var accountsCheckNameAvailability* = Call_AccountsCheckNameAvailability_564124(
    name: "accountsCheckNameAvailability", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.DataLakeAnalytics/locations/{location}/checkNameAvailability",
    validator: validate_AccountsCheckNameAvailability_564125, base: "",
    url: url_AccountsCheckNameAvailability_564126, schemes: {Scheme.Https})
type
  Call_AccountsListByResourceGroup_564153 = ref object of OpenApiRestCall_563564
proc url_AccountsListByResourceGroup_564155(protocol: Scheme; host: string;
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

proc validate_AccountsListByResourceGroup_564154(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the first page of Data Lake Analytics accounts, if any, within a specific resource group. This includes a link to the next page, if any.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Get subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the Azure resource group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564156 = path.getOrDefault("subscriptionId")
  valid_564156 = validateParameter(valid_564156, JString, required = true,
                                 default = nil)
  if valid_564156 != nil:
    section.add "subscriptionId", valid_564156
  var valid_564157 = path.getOrDefault("resourceGroupName")
  valid_564157 = validateParameter(valid_564157, JString, required = true,
                                 default = nil)
  if valid_564157 != nil:
    section.add "resourceGroupName", valid_564157
  result.add "path", section
  ## parameters in `query` object:
  ##   $top: JInt
  ##       : The number of items to return. Optional.
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   $select: JString
  ##          : OData Select statement. Limits the properties on each entry to just those requested, e.g. Categories?$select=CategoryName,Description. Optional.
  ##   $count: JBool
  ##         : The Boolean value of true or false to request a count of the matching resources included with the resources in the response, e.g. Categories?$count=true. Optional.
  ##   $orderby: JString
  ##           : OrderBy clause. One or more comma-separated expressions with an optional "asc" (the default) or "desc" depending on the order you'd like the values sorted, e.g. Categories?$orderby=CategoryName desc. Optional.
  ##   $skip: JInt
  ##        : The number of items to skip over before returning elements. Optional.
  ##   $filter: JString
  ##          : OData filter. Optional.
  section = newJObject()
  var valid_564158 = query.getOrDefault("$top")
  valid_564158 = validateParameter(valid_564158, JInt, required = false, default = nil)
  if valid_564158 != nil:
    section.add "$top", valid_564158
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564159 = query.getOrDefault("api-version")
  valid_564159 = validateParameter(valid_564159, JString, required = true,
                                 default = nil)
  if valid_564159 != nil:
    section.add "api-version", valid_564159
  var valid_564160 = query.getOrDefault("$select")
  valid_564160 = validateParameter(valid_564160, JString, required = false,
                                 default = nil)
  if valid_564160 != nil:
    section.add "$select", valid_564160
  var valid_564161 = query.getOrDefault("$count")
  valid_564161 = validateParameter(valid_564161, JBool, required = false, default = nil)
  if valid_564161 != nil:
    section.add "$count", valid_564161
  var valid_564162 = query.getOrDefault("$orderby")
  valid_564162 = validateParameter(valid_564162, JString, required = false,
                                 default = nil)
  if valid_564162 != nil:
    section.add "$orderby", valid_564162
  var valid_564163 = query.getOrDefault("$skip")
  valid_564163 = validateParameter(valid_564163, JInt, required = false, default = nil)
  if valid_564163 != nil:
    section.add "$skip", valid_564163
  var valid_564164 = query.getOrDefault("$filter")
  valid_564164 = validateParameter(valid_564164, JString, required = false,
                                 default = nil)
  if valid_564164 != nil:
    section.add "$filter", valid_564164
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564165: Call_AccountsListByResourceGroup_564153; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the first page of Data Lake Analytics accounts, if any, within a specific resource group. This includes a link to the next page, if any.
  ## 
  let valid = call_564165.validator(path, query, header, formData, body)
  let scheme = call_564165.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564165.url(scheme.get, call_564165.host, call_564165.base,
                         call_564165.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564165, url, valid)

proc call*(call_564166: Call_AccountsListByResourceGroup_564153;
          apiVersion: string; subscriptionId: string; resourceGroupName: string;
          Top: int = 0; Select: string = ""; Count: bool = false; Orderby: string = "";
          Skip: int = 0; Filter: string = ""): Recallable =
  ## accountsListByResourceGroup
  ## Gets the first page of Data Lake Analytics accounts, if any, within a specific resource group. This includes a link to the next page, if any.
  ##   Top: int
  ##      : The number of items to return. Optional.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   Select: string
  ##         : OData Select statement. Limits the properties on each entry to just those requested, e.g. Categories?$select=CategoryName,Description. Optional.
  ##   Count: bool
  ##        : The Boolean value of true or false to request a count of the matching resources included with the resources in the response, e.g. Categories?$count=true. Optional.
  ##   subscriptionId: string (required)
  ##                 : Get subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   Orderby: string
  ##          : OrderBy clause. One or more comma-separated expressions with an optional "asc" (the default) or "desc" depending on the order you'd like the values sorted, e.g. Categories?$orderby=CategoryName desc. Optional.
  ##   Skip: int
  ##       : The number of items to skip over before returning elements. Optional.
  ##   resourceGroupName: string (required)
  ##                    : The name of the Azure resource group.
  ##   Filter: string
  ##         : OData filter. Optional.
  var path_564167 = newJObject()
  var query_564168 = newJObject()
  add(query_564168, "$top", newJInt(Top))
  add(query_564168, "api-version", newJString(apiVersion))
  add(query_564168, "$select", newJString(Select))
  add(query_564168, "$count", newJBool(Count))
  add(path_564167, "subscriptionId", newJString(subscriptionId))
  add(query_564168, "$orderby", newJString(Orderby))
  add(query_564168, "$skip", newJInt(Skip))
  add(path_564167, "resourceGroupName", newJString(resourceGroupName))
  add(query_564168, "$filter", newJString(Filter))
  result = call_564166.call(path_564167, query_564168, nil, nil, nil)

var accountsListByResourceGroup* = Call_AccountsListByResourceGroup_564153(
    name: "accountsListByResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataLakeAnalytics/accounts",
    validator: validate_AccountsListByResourceGroup_564154, base: "",
    url: url_AccountsListByResourceGroup_564155, schemes: {Scheme.Https})
type
  Call_AccountsCreate_564180 = ref object of OpenApiRestCall_563564
proc url_AccountsCreate_564182(protocol: Scheme; host: string; base: string;
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

proc validate_AccountsCreate_564181(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Creates the specified Data Lake Analytics account. This supplies the user with computation services for Data Lake Analytics workloads.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Get subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the Azure resource group.
  ##   accountName: JString (required)
  ##              : The name of the Data Lake Analytics account.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564183 = path.getOrDefault("subscriptionId")
  valid_564183 = validateParameter(valid_564183, JString, required = true,
                                 default = nil)
  if valid_564183 != nil:
    section.add "subscriptionId", valid_564183
  var valid_564184 = path.getOrDefault("resourceGroupName")
  valid_564184 = validateParameter(valid_564184, JString, required = true,
                                 default = nil)
  if valid_564184 != nil:
    section.add "resourceGroupName", valid_564184
  var valid_564185 = path.getOrDefault("accountName")
  valid_564185 = validateParameter(valid_564185, JString, required = true,
                                 default = nil)
  if valid_564185 != nil:
    section.add "accountName", valid_564185
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564186 = query.getOrDefault("api-version")
  valid_564186 = validateParameter(valid_564186, JString, required = true,
                                 default = nil)
  if valid_564186 != nil:
    section.add "api-version", valid_564186
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

proc call*(call_564188: Call_AccountsCreate_564180; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates the specified Data Lake Analytics account. This supplies the user with computation services for Data Lake Analytics workloads.
  ## 
  let valid = call_564188.validator(path, query, header, formData, body)
  let scheme = call_564188.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564188.url(scheme.get, call_564188.host, call_564188.base,
                         call_564188.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564188, url, valid)

proc call*(call_564189: Call_AccountsCreate_564180; apiVersion: string;
          subscriptionId: string; resourceGroupName: string; parameters: JsonNode;
          accountName: string): Recallable =
  ## accountsCreate
  ## Creates the specified Data Lake Analytics account. This supplies the user with computation services for Data Lake Analytics workloads.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Get subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the Azure resource group.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to create a new Data Lake Analytics account.
  ##   accountName: string (required)
  ##              : The name of the Data Lake Analytics account.
  var path_564190 = newJObject()
  var query_564191 = newJObject()
  var body_564192 = newJObject()
  add(query_564191, "api-version", newJString(apiVersion))
  add(path_564190, "subscriptionId", newJString(subscriptionId))
  add(path_564190, "resourceGroupName", newJString(resourceGroupName))
  if parameters != nil:
    body_564192 = parameters
  add(path_564190, "accountName", newJString(accountName))
  result = call_564189.call(path_564190, query_564191, nil, nil, body_564192)

var accountsCreate* = Call_AccountsCreate_564180(name: "accountsCreate",
    meth: HttpMethod.HttpPut, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataLakeAnalytics/accounts/{accountName}",
    validator: validate_AccountsCreate_564181, base: "", url: url_AccountsCreate_564182,
    schemes: {Scheme.Https})
type
  Call_AccountsGet_564169 = ref object of OpenApiRestCall_563564
proc url_AccountsGet_564171(protocol: Scheme; host: string; base: string;
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

proc validate_AccountsGet_564170(path: JsonNode; query: JsonNode; header: JsonNode;
                                formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets details of the specified Data Lake Analytics account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Get subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the Azure resource group.
  ##   accountName: JString (required)
  ##              : The name of the Data Lake Analytics account.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564172 = path.getOrDefault("subscriptionId")
  valid_564172 = validateParameter(valid_564172, JString, required = true,
                                 default = nil)
  if valid_564172 != nil:
    section.add "subscriptionId", valid_564172
  var valid_564173 = path.getOrDefault("resourceGroupName")
  valid_564173 = validateParameter(valid_564173, JString, required = true,
                                 default = nil)
  if valid_564173 != nil:
    section.add "resourceGroupName", valid_564173
  var valid_564174 = path.getOrDefault("accountName")
  valid_564174 = validateParameter(valid_564174, JString, required = true,
                                 default = nil)
  if valid_564174 != nil:
    section.add "accountName", valid_564174
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564175 = query.getOrDefault("api-version")
  valid_564175 = validateParameter(valid_564175, JString, required = true,
                                 default = nil)
  if valid_564175 != nil:
    section.add "api-version", valid_564175
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564176: Call_AccountsGet_564169; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets details of the specified Data Lake Analytics account.
  ## 
  let valid = call_564176.validator(path, query, header, formData, body)
  let scheme = call_564176.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564176.url(scheme.get, call_564176.host, call_564176.base,
                         call_564176.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564176, url, valid)

proc call*(call_564177: Call_AccountsGet_564169; apiVersion: string;
          subscriptionId: string; resourceGroupName: string; accountName: string): Recallable =
  ## accountsGet
  ## Gets details of the specified Data Lake Analytics account.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Get subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the Azure resource group.
  ##   accountName: string (required)
  ##              : The name of the Data Lake Analytics account.
  var path_564178 = newJObject()
  var query_564179 = newJObject()
  add(query_564179, "api-version", newJString(apiVersion))
  add(path_564178, "subscriptionId", newJString(subscriptionId))
  add(path_564178, "resourceGroupName", newJString(resourceGroupName))
  add(path_564178, "accountName", newJString(accountName))
  result = call_564177.call(path_564178, query_564179, nil, nil, nil)

var accountsGet* = Call_AccountsGet_564169(name: "accountsGet",
                                        meth: HttpMethod.HttpGet,
                                        host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataLakeAnalytics/accounts/{accountName}",
                                        validator: validate_AccountsGet_564170,
                                        base: "", url: url_AccountsGet_564171,
                                        schemes: {Scheme.Https})
type
  Call_AccountsUpdate_564204 = ref object of OpenApiRestCall_563564
proc url_AccountsUpdate_564206(protocol: Scheme; host: string; base: string;
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

proc validate_AccountsUpdate_564205(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Updates the Data Lake Analytics account object specified by the accountName with the contents of the account object.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Get subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the Azure resource group.
  ##   accountName: JString (required)
  ##              : The name of the Data Lake Analytics account.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
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
  var valid_564209 = path.getOrDefault("accountName")
  valid_564209 = validateParameter(valid_564209, JString, required = true,
                                 default = nil)
  if valid_564209 != nil:
    section.add "accountName", valid_564209
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564210 = query.getOrDefault("api-version")
  valid_564210 = validateParameter(valid_564210, JString, required = true,
                                 default = nil)
  if valid_564210 != nil:
    section.add "api-version", valid_564210
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

proc call*(call_564212: Call_AccountsUpdate_564204; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the Data Lake Analytics account object specified by the accountName with the contents of the account object.
  ## 
  let valid = call_564212.validator(path, query, header, formData, body)
  let scheme = call_564212.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564212.url(scheme.get, call_564212.host, call_564212.base,
                         call_564212.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564212, url, valid)

proc call*(call_564213: Call_AccountsUpdate_564204; apiVersion: string;
          subscriptionId: string; resourceGroupName: string; accountName: string;
          parameters: JsonNode = nil): Recallable =
  ## accountsUpdate
  ## Updates the Data Lake Analytics account object specified by the accountName with the contents of the account object.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Get subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the Azure resource group.
  ##   parameters: JObject
  ##             : Parameters supplied to the update Data Lake Analytics account operation.
  ##   accountName: string (required)
  ##              : The name of the Data Lake Analytics account.
  var path_564214 = newJObject()
  var query_564215 = newJObject()
  var body_564216 = newJObject()
  add(query_564215, "api-version", newJString(apiVersion))
  add(path_564214, "subscriptionId", newJString(subscriptionId))
  add(path_564214, "resourceGroupName", newJString(resourceGroupName))
  if parameters != nil:
    body_564216 = parameters
  add(path_564214, "accountName", newJString(accountName))
  result = call_564213.call(path_564214, query_564215, nil, nil, body_564216)

var accountsUpdate* = Call_AccountsUpdate_564204(name: "accountsUpdate",
    meth: HttpMethod.HttpPatch, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataLakeAnalytics/accounts/{accountName}",
    validator: validate_AccountsUpdate_564205, base: "", url: url_AccountsUpdate_564206,
    schemes: {Scheme.Https})
type
  Call_AccountsDelete_564193 = ref object of OpenApiRestCall_563564
proc url_AccountsDelete_564195(protocol: Scheme; host: string; base: string;
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

proc validate_AccountsDelete_564194(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Begins the delete process for the Data Lake Analytics account object specified by the account name.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Get subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the Azure resource group.
  ##   accountName: JString (required)
  ##              : The name of the Data Lake Analytics account.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564196 = path.getOrDefault("subscriptionId")
  valid_564196 = validateParameter(valid_564196, JString, required = true,
                                 default = nil)
  if valid_564196 != nil:
    section.add "subscriptionId", valid_564196
  var valid_564197 = path.getOrDefault("resourceGroupName")
  valid_564197 = validateParameter(valid_564197, JString, required = true,
                                 default = nil)
  if valid_564197 != nil:
    section.add "resourceGroupName", valid_564197
  var valid_564198 = path.getOrDefault("accountName")
  valid_564198 = validateParameter(valid_564198, JString, required = true,
                                 default = nil)
  if valid_564198 != nil:
    section.add "accountName", valid_564198
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564199 = query.getOrDefault("api-version")
  valid_564199 = validateParameter(valid_564199, JString, required = true,
                                 default = nil)
  if valid_564199 != nil:
    section.add "api-version", valid_564199
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564200: Call_AccountsDelete_564193; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Begins the delete process for the Data Lake Analytics account object specified by the account name.
  ## 
  let valid = call_564200.validator(path, query, header, formData, body)
  let scheme = call_564200.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564200.url(scheme.get, call_564200.host, call_564200.base,
                         call_564200.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564200, url, valid)

proc call*(call_564201: Call_AccountsDelete_564193; apiVersion: string;
          subscriptionId: string; resourceGroupName: string; accountName: string): Recallable =
  ## accountsDelete
  ## Begins the delete process for the Data Lake Analytics account object specified by the account name.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Get subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the Azure resource group.
  ##   accountName: string (required)
  ##              : The name of the Data Lake Analytics account.
  var path_564202 = newJObject()
  var query_564203 = newJObject()
  add(query_564203, "api-version", newJString(apiVersion))
  add(path_564202, "subscriptionId", newJString(subscriptionId))
  add(path_564202, "resourceGroupName", newJString(resourceGroupName))
  add(path_564202, "accountName", newJString(accountName))
  result = call_564201.call(path_564202, query_564203, nil, nil, nil)

var accountsDelete* = Call_AccountsDelete_564193(name: "accountsDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataLakeAnalytics/accounts/{accountName}",
    validator: validate_AccountsDelete_564194, base: "", url: url_AccountsDelete_564195,
    schemes: {Scheme.Https})
type
  Call_ComputePoliciesListByAccount_564217 = ref object of OpenApiRestCall_563564
proc url_ComputePoliciesListByAccount_564219(protocol: Scheme; host: string;
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

proc validate_ComputePoliciesListByAccount_564218(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists the Data Lake Analytics compute policies within the specified Data Lake Analytics account. An account supports, at most, 50 policies
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Get subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the Azure resource group.
  ##   accountName: JString (required)
  ##              : The name of the Data Lake Analytics account.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
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
  var valid_564222 = path.getOrDefault("accountName")
  valid_564222 = validateParameter(valid_564222, JString, required = true,
                                 default = nil)
  if valid_564222 != nil:
    section.add "accountName", valid_564222
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564223 = query.getOrDefault("api-version")
  valid_564223 = validateParameter(valid_564223, JString, required = true,
                                 default = nil)
  if valid_564223 != nil:
    section.add "api-version", valid_564223
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564224: Call_ComputePoliciesListByAccount_564217; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the Data Lake Analytics compute policies within the specified Data Lake Analytics account. An account supports, at most, 50 policies
  ## 
  let valid = call_564224.validator(path, query, header, formData, body)
  let scheme = call_564224.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564224.url(scheme.get, call_564224.host, call_564224.base,
                         call_564224.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564224, url, valid)

proc call*(call_564225: Call_ComputePoliciesListByAccount_564217;
          apiVersion: string; subscriptionId: string; resourceGroupName: string;
          accountName: string): Recallable =
  ## computePoliciesListByAccount
  ## Lists the Data Lake Analytics compute policies within the specified Data Lake Analytics account. An account supports, at most, 50 policies
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Get subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the Azure resource group.
  ##   accountName: string (required)
  ##              : The name of the Data Lake Analytics account.
  var path_564226 = newJObject()
  var query_564227 = newJObject()
  add(query_564227, "api-version", newJString(apiVersion))
  add(path_564226, "subscriptionId", newJString(subscriptionId))
  add(path_564226, "resourceGroupName", newJString(resourceGroupName))
  add(path_564226, "accountName", newJString(accountName))
  result = call_564225.call(path_564226, query_564227, nil, nil, nil)

var computePoliciesListByAccount* = Call_ComputePoliciesListByAccount_564217(
    name: "computePoliciesListByAccount", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataLakeAnalytics/accounts/{accountName}/computePolicies",
    validator: validate_ComputePoliciesListByAccount_564218, base: "",
    url: url_ComputePoliciesListByAccount_564219, schemes: {Scheme.Https})
type
  Call_ComputePoliciesCreateOrUpdate_564240 = ref object of OpenApiRestCall_563564
proc url_ComputePoliciesCreateOrUpdate_564242(protocol: Scheme; host: string;
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

proc validate_ComputePoliciesCreateOrUpdate_564241(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates or updates the specified compute policy. During update, the compute policy with the specified name will be replaced with this new compute policy. An account supports, at most, 50 policies
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   computePolicyName: JString (required)
  ##                    : The name of the compute policy to create or update.
  ##   subscriptionId: JString (required)
  ##                 : Get subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the Azure resource group.
  ##   accountName: JString (required)
  ##              : The name of the Data Lake Analytics account.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `computePolicyName` field"
  var valid_564243 = path.getOrDefault("computePolicyName")
  valid_564243 = validateParameter(valid_564243, JString, required = true,
                                 default = nil)
  if valid_564243 != nil:
    section.add "computePolicyName", valid_564243
  var valid_564244 = path.getOrDefault("subscriptionId")
  valid_564244 = validateParameter(valid_564244, JString, required = true,
                                 default = nil)
  if valid_564244 != nil:
    section.add "subscriptionId", valid_564244
  var valid_564245 = path.getOrDefault("resourceGroupName")
  valid_564245 = validateParameter(valid_564245, JString, required = true,
                                 default = nil)
  if valid_564245 != nil:
    section.add "resourceGroupName", valid_564245
  var valid_564246 = path.getOrDefault("accountName")
  valid_564246 = validateParameter(valid_564246, JString, required = true,
                                 default = nil)
  if valid_564246 != nil:
    section.add "accountName", valid_564246
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564247 = query.getOrDefault("api-version")
  valid_564247 = validateParameter(valid_564247, JString, required = true,
                                 default = nil)
  if valid_564247 != nil:
    section.add "api-version", valid_564247
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

proc call*(call_564249: Call_ComputePoliciesCreateOrUpdate_564240; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates or updates the specified compute policy. During update, the compute policy with the specified name will be replaced with this new compute policy. An account supports, at most, 50 policies
  ## 
  let valid = call_564249.validator(path, query, header, formData, body)
  let scheme = call_564249.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564249.url(scheme.get, call_564249.host, call_564249.base,
                         call_564249.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564249, url, valid)

proc call*(call_564250: Call_ComputePoliciesCreateOrUpdate_564240;
          computePolicyName: string; apiVersion: string; subscriptionId: string;
          resourceGroupName: string; parameters: JsonNode; accountName: string): Recallable =
  ## computePoliciesCreateOrUpdate
  ## Creates or updates the specified compute policy. During update, the compute policy with the specified name will be replaced with this new compute policy. An account supports, at most, 50 policies
  ##   computePolicyName: string (required)
  ##                    : The name of the compute policy to create or update.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Get subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the Azure resource group.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to create or update the compute policy. The max degree of parallelism per job property, min priority per job property, or both must be present.
  ##   accountName: string (required)
  ##              : The name of the Data Lake Analytics account.
  var path_564251 = newJObject()
  var query_564252 = newJObject()
  var body_564253 = newJObject()
  add(path_564251, "computePolicyName", newJString(computePolicyName))
  add(query_564252, "api-version", newJString(apiVersion))
  add(path_564251, "subscriptionId", newJString(subscriptionId))
  add(path_564251, "resourceGroupName", newJString(resourceGroupName))
  if parameters != nil:
    body_564253 = parameters
  add(path_564251, "accountName", newJString(accountName))
  result = call_564250.call(path_564251, query_564252, nil, nil, body_564253)

var computePoliciesCreateOrUpdate* = Call_ComputePoliciesCreateOrUpdate_564240(
    name: "computePoliciesCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataLakeAnalytics/accounts/{accountName}/computePolicies/{computePolicyName}",
    validator: validate_ComputePoliciesCreateOrUpdate_564241, base: "",
    url: url_ComputePoliciesCreateOrUpdate_564242, schemes: {Scheme.Https})
type
  Call_ComputePoliciesGet_564228 = ref object of OpenApiRestCall_563564
proc url_ComputePoliciesGet_564230(protocol: Scheme; host: string; base: string;
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

proc validate_ComputePoliciesGet_564229(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Gets the specified Data Lake Analytics compute policy.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   computePolicyName: JString (required)
  ##                    : The name of the compute policy to retrieve.
  ##   subscriptionId: JString (required)
  ##                 : Get subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the Azure resource group.
  ##   accountName: JString (required)
  ##              : The name of the Data Lake Analytics account.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `computePolicyName` field"
  var valid_564231 = path.getOrDefault("computePolicyName")
  valid_564231 = validateParameter(valid_564231, JString, required = true,
                                 default = nil)
  if valid_564231 != nil:
    section.add "computePolicyName", valid_564231
  var valid_564232 = path.getOrDefault("subscriptionId")
  valid_564232 = validateParameter(valid_564232, JString, required = true,
                                 default = nil)
  if valid_564232 != nil:
    section.add "subscriptionId", valid_564232
  var valid_564233 = path.getOrDefault("resourceGroupName")
  valid_564233 = validateParameter(valid_564233, JString, required = true,
                                 default = nil)
  if valid_564233 != nil:
    section.add "resourceGroupName", valid_564233
  var valid_564234 = path.getOrDefault("accountName")
  valid_564234 = validateParameter(valid_564234, JString, required = true,
                                 default = nil)
  if valid_564234 != nil:
    section.add "accountName", valid_564234
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564235 = query.getOrDefault("api-version")
  valid_564235 = validateParameter(valid_564235, JString, required = true,
                                 default = nil)
  if valid_564235 != nil:
    section.add "api-version", valid_564235
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564236: Call_ComputePoliciesGet_564228; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the specified Data Lake Analytics compute policy.
  ## 
  let valid = call_564236.validator(path, query, header, formData, body)
  let scheme = call_564236.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564236.url(scheme.get, call_564236.host, call_564236.base,
                         call_564236.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564236, url, valid)

proc call*(call_564237: Call_ComputePoliciesGet_564228; computePolicyName: string;
          apiVersion: string; subscriptionId: string; resourceGroupName: string;
          accountName: string): Recallable =
  ## computePoliciesGet
  ## Gets the specified Data Lake Analytics compute policy.
  ##   computePolicyName: string (required)
  ##                    : The name of the compute policy to retrieve.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Get subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the Azure resource group.
  ##   accountName: string (required)
  ##              : The name of the Data Lake Analytics account.
  var path_564238 = newJObject()
  var query_564239 = newJObject()
  add(path_564238, "computePolicyName", newJString(computePolicyName))
  add(query_564239, "api-version", newJString(apiVersion))
  add(path_564238, "subscriptionId", newJString(subscriptionId))
  add(path_564238, "resourceGroupName", newJString(resourceGroupName))
  add(path_564238, "accountName", newJString(accountName))
  result = call_564237.call(path_564238, query_564239, nil, nil, nil)

var computePoliciesGet* = Call_ComputePoliciesGet_564228(
    name: "computePoliciesGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataLakeAnalytics/accounts/{accountName}/computePolicies/{computePolicyName}",
    validator: validate_ComputePoliciesGet_564229, base: "",
    url: url_ComputePoliciesGet_564230, schemes: {Scheme.Https})
type
  Call_ComputePoliciesUpdate_564266 = ref object of OpenApiRestCall_563564
proc url_ComputePoliciesUpdate_564268(protocol: Scheme; host: string; base: string;
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

proc validate_ComputePoliciesUpdate_564267(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates the specified compute policy.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   computePolicyName: JString (required)
  ##                    : The name of the compute policy to update.
  ##   subscriptionId: JString (required)
  ##                 : Get subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the Azure resource group.
  ##   accountName: JString (required)
  ##              : The name of the Data Lake Analytics account.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `computePolicyName` field"
  var valid_564269 = path.getOrDefault("computePolicyName")
  valid_564269 = validateParameter(valid_564269, JString, required = true,
                                 default = nil)
  if valid_564269 != nil:
    section.add "computePolicyName", valid_564269
  var valid_564270 = path.getOrDefault("subscriptionId")
  valid_564270 = validateParameter(valid_564270, JString, required = true,
                                 default = nil)
  if valid_564270 != nil:
    section.add "subscriptionId", valid_564270
  var valid_564271 = path.getOrDefault("resourceGroupName")
  valid_564271 = validateParameter(valid_564271, JString, required = true,
                                 default = nil)
  if valid_564271 != nil:
    section.add "resourceGroupName", valid_564271
  var valid_564272 = path.getOrDefault("accountName")
  valid_564272 = validateParameter(valid_564272, JString, required = true,
                                 default = nil)
  if valid_564272 != nil:
    section.add "accountName", valid_564272
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564273 = query.getOrDefault("api-version")
  valid_564273 = validateParameter(valid_564273, JString, required = true,
                                 default = nil)
  if valid_564273 != nil:
    section.add "api-version", valid_564273
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

proc call*(call_564275: Call_ComputePoliciesUpdate_564266; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the specified compute policy.
  ## 
  let valid = call_564275.validator(path, query, header, formData, body)
  let scheme = call_564275.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564275.url(scheme.get, call_564275.host, call_564275.base,
                         call_564275.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564275, url, valid)

proc call*(call_564276: Call_ComputePoliciesUpdate_564266;
          computePolicyName: string; apiVersion: string; subscriptionId: string;
          resourceGroupName: string; accountName: string; parameters: JsonNode = nil): Recallable =
  ## computePoliciesUpdate
  ## Updates the specified compute policy.
  ##   computePolicyName: string (required)
  ##                    : The name of the compute policy to update.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Get subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the Azure resource group.
  ##   parameters: JObject
  ##             : Parameters supplied to update the compute policy.
  ##   accountName: string (required)
  ##              : The name of the Data Lake Analytics account.
  var path_564277 = newJObject()
  var query_564278 = newJObject()
  var body_564279 = newJObject()
  add(path_564277, "computePolicyName", newJString(computePolicyName))
  add(query_564278, "api-version", newJString(apiVersion))
  add(path_564277, "subscriptionId", newJString(subscriptionId))
  add(path_564277, "resourceGroupName", newJString(resourceGroupName))
  if parameters != nil:
    body_564279 = parameters
  add(path_564277, "accountName", newJString(accountName))
  result = call_564276.call(path_564277, query_564278, nil, nil, body_564279)

var computePoliciesUpdate* = Call_ComputePoliciesUpdate_564266(
    name: "computePoliciesUpdate", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataLakeAnalytics/accounts/{accountName}/computePolicies/{computePolicyName}",
    validator: validate_ComputePoliciesUpdate_564267, base: "",
    url: url_ComputePoliciesUpdate_564268, schemes: {Scheme.Https})
type
  Call_ComputePoliciesDelete_564254 = ref object of OpenApiRestCall_563564
proc url_ComputePoliciesDelete_564256(protocol: Scheme; host: string; base: string;
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

proc validate_ComputePoliciesDelete_564255(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes the specified compute policy from the specified Data Lake Analytics account
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   computePolicyName: JString (required)
  ##                    : The name of the compute policy to delete.
  ##   subscriptionId: JString (required)
  ##                 : Get subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the Azure resource group.
  ##   accountName: JString (required)
  ##              : The name of the Data Lake Analytics account.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `computePolicyName` field"
  var valid_564257 = path.getOrDefault("computePolicyName")
  valid_564257 = validateParameter(valid_564257, JString, required = true,
                                 default = nil)
  if valid_564257 != nil:
    section.add "computePolicyName", valid_564257
  var valid_564258 = path.getOrDefault("subscriptionId")
  valid_564258 = validateParameter(valid_564258, JString, required = true,
                                 default = nil)
  if valid_564258 != nil:
    section.add "subscriptionId", valid_564258
  var valid_564259 = path.getOrDefault("resourceGroupName")
  valid_564259 = validateParameter(valid_564259, JString, required = true,
                                 default = nil)
  if valid_564259 != nil:
    section.add "resourceGroupName", valid_564259
  var valid_564260 = path.getOrDefault("accountName")
  valid_564260 = validateParameter(valid_564260, JString, required = true,
                                 default = nil)
  if valid_564260 != nil:
    section.add "accountName", valid_564260
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564261 = query.getOrDefault("api-version")
  valid_564261 = validateParameter(valid_564261, JString, required = true,
                                 default = nil)
  if valid_564261 != nil:
    section.add "api-version", valid_564261
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564262: Call_ComputePoliciesDelete_564254; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the specified compute policy from the specified Data Lake Analytics account
  ## 
  let valid = call_564262.validator(path, query, header, formData, body)
  let scheme = call_564262.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564262.url(scheme.get, call_564262.host, call_564262.base,
                         call_564262.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564262, url, valid)

proc call*(call_564263: Call_ComputePoliciesDelete_564254;
          computePolicyName: string; apiVersion: string; subscriptionId: string;
          resourceGroupName: string; accountName: string): Recallable =
  ## computePoliciesDelete
  ## Deletes the specified compute policy from the specified Data Lake Analytics account
  ##   computePolicyName: string (required)
  ##                    : The name of the compute policy to delete.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Get subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the Azure resource group.
  ##   accountName: string (required)
  ##              : The name of the Data Lake Analytics account.
  var path_564264 = newJObject()
  var query_564265 = newJObject()
  add(path_564264, "computePolicyName", newJString(computePolicyName))
  add(query_564265, "api-version", newJString(apiVersion))
  add(path_564264, "subscriptionId", newJString(subscriptionId))
  add(path_564264, "resourceGroupName", newJString(resourceGroupName))
  add(path_564264, "accountName", newJString(accountName))
  result = call_564263.call(path_564264, query_564265, nil, nil, nil)

var computePoliciesDelete* = Call_ComputePoliciesDelete_564254(
    name: "computePoliciesDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataLakeAnalytics/accounts/{accountName}/computePolicies/{computePolicyName}",
    validator: validate_ComputePoliciesDelete_564255, base: "",
    url: url_ComputePoliciesDelete_564256, schemes: {Scheme.Https})
type
  Call_DataLakeStoreAccountsListByAccount_564280 = ref object of OpenApiRestCall_563564
proc url_DataLakeStoreAccountsListByAccount_564282(protocol: Scheme; host: string;
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

proc validate_DataLakeStoreAccountsListByAccount_564281(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the first page of Data Lake Store accounts linked to the specified Data Lake Analytics account. The response includes a link to the next page, if any.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Get subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the Azure resource group.
  ##   accountName: JString (required)
  ##              : The name of the Data Lake Analytics account.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564283 = path.getOrDefault("subscriptionId")
  valid_564283 = validateParameter(valid_564283, JString, required = true,
                                 default = nil)
  if valid_564283 != nil:
    section.add "subscriptionId", valid_564283
  var valid_564284 = path.getOrDefault("resourceGroupName")
  valid_564284 = validateParameter(valid_564284, JString, required = true,
                                 default = nil)
  if valid_564284 != nil:
    section.add "resourceGroupName", valid_564284
  var valid_564285 = path.getOrDefault("accountName")
  valid_564285 = validateParameter(valid_564285, JString, required = true,
                                 default = nil)
  if valid_564285 != nil:
    section.add "accountName", valid_564285
  result.add "path", section
  ## parameters in `query` object:
  ##   $top: JInt
  ##       : The number of items to return. Optional.
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   $select: JString
  ##          : OData Select statement. Limits the properties on each entry to just those requested, e.g. Categories?$select=CategoryName,Description. Optional.
  ##   $count: JBool
  ##         : The Boolean value of true or false to request a count of the matching resources included with the resources in the response, e.g. Categories?$count=true. Optional.
  ##   $orderby: JString
  ##           : OrderBy clause. One or more comma-separated expressions with an optional "asc" (the default) or "desc" depending on the order you'd like the values sorted, e.g. Categories?$orderby=CategoryName desc. Optional.
  ##   $skip: JInt
  ##        : The number of items to skip over before returning elements. Optional.
  ##   $filter: JString
  ##          : OData filter. Optional.
  section = newJObject()
  var valid_564286 = query.getOrDefault("$top")
  valid_564286 = validateParameter(valid_564286, JInt, required = false, default = nil)
  if valid_564286 != nil:
    section.add "$top", valid_564286
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564287 = query.getOrDefault("api-version")
  valid_564287 = validateParameter(valid_564287, JString, required = true,
                                 default = nil)
  if valid_564287 != nil:
    section.add "api-version", valid_564287
  var valid_564288 = query.getOrDefault("$select")
  valid_564288 = validateParameter(valid_564288, JString, required = false,
                                 default = nil)
  if valid_564288 != nil:
    section.add "$select", valid_564288
  var valid_564289 = query.getOrDefault("$count")
  valid_564289 = validateParameter(valid_564289, JBool, required = false, default = nil)
  if valid_564289 != nil:
    section.add "$count", valid_564289
  var valid_564290 = query.getOrDefault("$orderby")
  valid_564290 = validateParameter(valid_564290, JString, required = false,
                                 default = nil)
  if valid_564290 != nil:
    section.add "$orderby", valid_564290
  var valid_564291 = query.getOrDefault("$skip")
  valid_564291 = validateParameter(valid_564291, JInt, required = false, default = nil)
  if valid_564291 != nil:
    section.add "$skip", valid_564291
  var valid_564292 = query.getOrDefault("$filter")
  valid_564292 = validateParameter(valid_564292, JString, required = false,
                                 default = nil)
  if valid_564292 != nil:
    section.add "$filter", valid_564292
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564293: Call_DataLakeStoreAccountsListByAccount_564280;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the first page of Data Lake Store accounts linked to the specified Data Lake Analytics account. The response includes a link to the next page, if any.
  ## 
  let valid = call_564293.validator(path, query, header, formData, body)
  let scheme = call_564293.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564293.url(scheme.get, call_564293.host, call_564293.base,
                         call_564293.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564293, url, valid)

proc call*(call_564294: Call_DataLakeStoreAccountsListByAccount_564280;
          apiVersion: string; subscriptionId: string; resourceGroupName: string;
          accountName: string; Top: int = 0; Select: string = ""; Count: bool = false;
          Orderby: string = ""; Skip: int = 0; Filter: string = ""): Recallable =
  ## dataLakeStoreAccountsListByAccount
  ## Gets the first page of Data Lake Store accounts linked to the specified Data Lake Analytics account. The response includes a link to the next page, if any.
  ##   Top: int
  ##      : The number of items to return. Optional.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   Select: string
  ##         : OData Select statement. Limits the properties on each entry to just those requested, e.g. Categories?$select=CategoryName,Description. Optional.
  ##   Count: bool
  ##        : The Boolean value of true or false to request a count of the matching resources included with the resources in the response, e.g. Categories?$count=true. Optional.
  ##   subscriptionId: string (required)
  ##                 : Get subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   Orderby: string
  ##          : OrderBy clause. One or more comma-separated expressions with an optional "asc" (the default) or "desc" depending on the order you'd like the values sorted, e.g. Categories?$orderby=CategoryName desc. Optional.
  ##   Skip: int
  ##       : The number of items to skip over before returning elements. Optional.
  ##   resourceGroupName: string (required)
  ##                    : The name of the Azure resource group.
  ##   Filter: string
  ##         : OData filter. Optional.
  ##   accountName: string (required)
  ##              : The name of the Data Lake Analytics account.
  var path_564295 = newJObject()
  var query_564296 = newJObject()
  add(query_564296, "$top", newJInt(Top))
  add(query_564296, "api-version", newJString(apiVersion))
  add(query_564296, "$select", newJString(Select))
  add(query_564296, "$count", newJBool(Count))
  add(path_564295, "subscriptionId", newJString(subscriptionId))
  add(query_564296, "$orderby", newJString(Orderby))
  add(query_564296, "$skip", newJInt(Skip))
  add(path_564295, "resourceGroupName", newJString(resourceGroupName))
  add(query_564296, "$filter", newJString(Filter))
  add(path_564295, "accountName", newJString(accountName))
  result = call_564294.call(path_564295, query_564296, nil, nil, nil)

var dataLakeStoreAccountsListByAccount* = Call_DataLakeStoreAccountsListByAccount_564280(
    name: "dataLakeStoreAccountsListByAccount", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataLakeAnalytics/accounts/{accountName}/dataLakeStoreAccounts",
    validator: validate_DataLakeStoreAccountsListByAccount_564281, base: "",
    url: url_DataLakeStoreAccountsListByAccount_564282, schemes: {Scheme.Https})
type
  Call_DataLakeStoreAccountsAdd_564309 = ref object of OpenApiRestCall_563564
proc url_DataLakeStoreAccountsAdd_564311(protocol: Scheme; host: string;
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

proc validate_DataLakeStoreAccountsAdd_564310(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
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
  ##                    : The name of the Azure resource group.
  ##   accountName: JString (required)
  ##              : The name of the Data Lake Analytics account.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564312 = path.getOrDefault("subscriptionId")
  valid_564312 = validateParameter(valid_564312, JString, required = true,
                                 default = nil)
  if valid_564312 != nil:
    section.add "subscriptionId", valid_564312
  var valid_564313 = path.getOrDefault("dataLakeStoreAccountName")
  valid_564313 = validateParameter(valid_564313, JString, required = true,
                                 default = nil)
  if valid_564313 != nil:
    section.add "dataLakeStoreAccountName", valid_564313
  var valid_564314 = path.getOrDefault("resourceGroupName")
  valid_564314 = validateParameter(valid_564314, JString, required = true,
                                 default = nil)
  if valid_564314 != nil:
    section.add "resourceGroupName", valid_564314
  var valid_564315 = path.getOrDefault("accountName")
  valid_564315 = validateParameter(valid_564315, JString, required = true,
                                 default = nil)
  if valid_564315 != nil:
    section.add "accountName", valid_564315
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564316 = query.getOrDefault("api-version")
  valid_564316 = validateParameter(valid_564316, JString, required = true,
                                 default = nil)
  if valid_564316 != nil:
    section.add "api-version", valid_564316
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

proc call*(call_564318: Call_DataLakeStoreAccountsAdd_564309; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the specified Data Lake Analytics account to include the additional Data Lake Store account.
  ## 
  let valid = call_564318.validator(path, query, header, formData, body)
  let scheme = call_564318.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564318.url(scheme.get, call_564318.host, call_564318.base,
                         call_564318.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564318, url, valid)

proc call*(call_564319: Call_DataLakeStoreAccountsAdd_564309; apiVersion: string;
          subscriptionId: string; dataLakeStoreAccountName: string;
          resourceGroupName: string; accountName: string; parameters: JsonNode = nil): Recallable =
  ## dataLakeStoreAccountsAdd
  ## Updates the specified Data Lake Analytics account to include the additional Data Lake Store account.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Get subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   dataLakeStoreAccountName: string (required)
  ##                           : The name of the Data Lake Store account to add.
  ##   resourceGroupName: string (required)
  ##                    : The name of the Azure resource group.
  ##   parameters: JObject
  ##             : The details of the Data Lake Store account.
  ##   accountName: string (required)
  ##              : The name of the Data Lake Analytics account.
  var path_564320 = newJObject()
  var query_564321 = newJObject()
  var body_564322 = newJObject()
  add(query_564321, "api-version", newJString(apiVersion))
  add(path_564320, "subscriptionId", newJString(subscriptionId))
  add(path_564320, "dataLakeStoreAccountName",
      newJString(dataLakeStoreAccountName))
  add(path_564320, "resourceGroupName", newJString(resourceGroupName))
  if parameters != nil:
    body_564322 = parameters
  add(path_564320, "accountName", newJString(accountName))
  result = call_564319.call(path_564320, query_564321, nil, nil, body_564322)

var dataLakeStoreAccountsAdd* = Call_DataLakeStoreAccountsAdd_564309(
    name: "dataLakeStoreAccountsAdd", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataLakeAnalytics/accounts/{accountName}/dataLakeStoreAccounts/{dataLakeStoreAccountName}",
    validator: validate_DataLakeStoreAccountsAdd_564310, base: "",
    url: url_DataLakeStoreAccountsAdd_564311, schemes: {Scheme.Https})
type
  Call_DataLakeStoreAccountsGet_564297 = ref object of OpenApiRestCall_563564
proc url_DataLakeStoreAccountsGet_564299(protocol: Scheme; host: string;
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

proc validate_DataLakeStoreAccountsGet_564298(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
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
  ##                    : The name of the Azure resource group.
  ##   accountName: JString (required)
  ##              : The name of the Data Lake Analytics account.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564300 = path.getOrDefault("subscriptionId")
  valid_564300 = validateParameter(valid_564300, JString, required = true,
                                 default = nil)
  if valid_564300 != nil:
    section.add "subscriptionId", valid_564300
  var valid_564301 = path.getOrDefault("dataLakeStoreAccountName")
  valid_564301 = validateParameter(valid_564301, JString, required = true,
                                 default = nil)
  if valid_564301 != nil:
    section.add "dataLakeStoreAccountName", valid_564301
  var valid_564302 = path.getOrDefault("resourceGroupName")
  valid_564302 = validateParameter(valid_564302, JString, required = true,
                                 default = nil)
  if valid_564302 != nil:
    section.add "resourceGroupName", valid_564302
  var valid_564303 = path.getOrDefault("accountName")
  valid_564303 = validateParameter(valid_564303, JString, required = true,
                                 default = nil)
  if valid_564303 != nil:
    section.add "accountName", valid_564303
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564304 = query.getOrDefault("api-version")
  valid_564304 = validateParameter(valid_564304, JString, required = true,
                                 default = nil)
  if valid_564304 != nil:
    section.add "api-version", valid_564304
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564305: Call_DataLakeStoreAccountsGet_564297; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the specified Data Lake Store account details in the specified Data Lake Analytics account.
  ## 
  let valid = call_564305.validator(path, query, header, formData, body)
  let scheme = call_564305.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564305.url(scheme.get, call_564305.host, call_564305.base,
                         call_564305.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564305, url, valid)

proc call*(call_564306: Call_DataLakeStoreAccountsGet_564297; apiVersion: string;
          subscriptionId: string; dataLakeStoreAccountName: string;
          resourceGroupName: string; accountName: string): Recallable =
  ## dataLakeStoreAccountsGet
  ## Gets the specified Data Lake Store account details in the specified Data Lake Analytics account.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Get subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   dataLakeStoreAccountName: string (required)
  ##                           : The name of the Data Lake Store account to retrieve
  ##   resourceGroupName: string (required)
  ##                    : The name of the Azure resource group.
  ##   accountName: string (required)
  ##              : The name of the Data Lake Analytics account.
  var path_564307 = newJObject()
  var query_564308 = newJObject()
  add(query_564308, "api-version", newJString(apiVersion))
  add(path_564307, "subscriptionId", newJString(subscriptionId))
  add(path_564307, "dataLakeStoreAccountName",
      newJString(dataLakeStoreAccountName))
  add(path_564307, "resourceGroupName", newJString(resourceGroupName))
  add(path_564307, "accountName", newJString(accountName))
  result = call_564306.call(path_564307, query_564308, nil, nil, nil)

var dataLakeStoreAccountsGet* = Call_DataLakeStoreAccountsGet_564297(
    name: "dataLakeStoreAccountsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataLakeAnalytics/accounts/{accountName}/dataLakeStoreAccounts/{dataLakeStoreAccountName}",
    validator: validate_DataLakeStoreAccountsGet_564298, base: "",
    url: url_DataLakeStoreAccountsGet_564299, schemes: {Scheme.Https})
type
  Call_DataLakeStoreAccountsDelete_564323 = ref object of OpenApiRestCall_563564
proc url_DataLakeStoreAccountsDelete_564325(protocol: Scheme; host: string;
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

proc validate_DataLakeStoreAccountsDelete_564324(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
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
  ##                    : The name of the Azure resource group.
  ##   accountName: JString (required)
  ##              : The name of the Data Lake Analytics account.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564326 = path.getOrDefault("subscriptionId")
  valid_564326 = validateParameter(valid_564326, JString, required = true,
                                 default = nil)
  if valid_564326 != nil:
    section.add "subscriptionId", valid_564326
  var valid_564327 = path.getOrDefault("dataLakeStoreAccountName")
  valid_564327 = validateParameter(valid_564327, JString, required = true,
                                 default = nil)
  if valid_564327 != nil:
    section.add "dataLakeStoreAccountName", valid_564327
  var valid_564328 = path.getOrDefault("resourceGroupName")
  valid_564328 = validateParameter(valid_564328, JString, required = true,
                                 default = nil)
  if valid_564328 != nil:
    section.add "resourceGroupName", valid_564328
  var valid_564329 = path.getOrDefault("accountName")
  valid_564329 = validateParameter(valid_564329, JString, required = true,
                                 default = nil)
  if valid_564329 != nil:
    section.add "accountName", valid_564329
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
  if body != nil:
    result.add "body", body

proc call*(call_564331: Call_DataLakeStoreAccountsDelete_564323; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the Data Lake Analytics account specified to remove the specified Data Lake Store account.
  ## 
  let valid = call_564331.validator(path, query, header, formData, body)
  let scheme = call_564331.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564331.url(scheme.get, call_564331.host, call_564331.base,
                         call_564331.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564331, url, valid)

proc call*(call_564332: Call_DataLakeStoreAccountsDelete_564323;
          apiVersion: string; subscriptionId: string;
          dataLakeStoreAccountName: string; resourceGroupName: string;
          accountName: string): Recallable =
  ## dataLakeStoreAccountsDelete
  ## Updates the Data Lake Analytics account specified to remove the specified Data Lake Store account.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Get subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   dataLakeStoreAccountName: string (required)
  ##                           : The name of the Data Lake Store account to remove
  ##   resourceGroupName: string (required)
  ##                    : The name of the Azure resource group.
  ##   accountName: string (required)
  ##              : The name of the Data Lake Analytics account.
  var path_564333 = newJObject()
  var query_564334 = newJObject()
  add(query_564334, "api-version", newJString(apiVersion))
  add(path_564333, "subscriptionId", newJString(subscriptionId))
  add(path_564333, "dataLakeStoreAccountName",
      newJString(dataLakeStoreAccountName))
  add(path_564333, "resourceGroupName", newJString(resourceGroupName))
  add(path_564333, "accountName", newJString(accountName))
  result = call_564332.call(path_564333, query_564334, nil, nil, nil)

var dataLakeStoreAccountsDelete* = Call_DataLakeStoreAccountsDelete_564323(
    name: "dataLakeStoreAccountsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataLakeAnalytics/accounts/{accountName}/dataLakeStoreAccounts/{dataLakeStoreAccountName}",
    validator: validate_DataLakeStoreAccountsDelete_564324, base: "",
    url: url_DataLakeStoreAccountsDelete_564325, schemes: {Scheme.Https})
type
  Call_FirewallRulesListByAccount_564335 = ref object of OpenApiRestCall_563564
proc url_FirewallRulesListByAccount_564337(protocol: Scheme; host: string;
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

proc validate_FirewallRulesListByAccount_564336(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists the Data Lake Analytics firewall rules within the specified Data Lake Analytics account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Get subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the Azure resource group.
  ##   accountName: JString (required)
  ##              : The name of the Data Lake Analytics account.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564338 = path.getOrDefault("subscriptionId")
  valid_564338 = validateParameter(valid_564338, JString, required = true,
                                 default = nil)
  if valid_564338 != nil:
    section.add "subscriptionId", valid_564338
  var valid_564339 = path.getOrDefault("resourceGroupName")
  valid_564339 = validateParameter(valid_564339, JString, required = true,
                                 default = nil)
  if valid_564339 != nil:
    section.add "resourceGroupName", valid_564339
  var valid_564340 = path.getOrDefault("accountName")
  valid_564340 = validateParameter(valid_564340, JString, required = true,
                                 default = nil)
  if valid_564340 != nil:
    section.add "accountName", valid_564340
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564341 = query.getOrDefault("api-version")
  valid_564341 = validateParameter(valid_564341, JString, required = true,
                                 default = nil)
  if valid_564341 != nil:
    section.add "api-version", valid_564341
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564342: Call_FirewallRulesListByAccount_564335; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the Data Lake Analytics firewall rules within the specified Data Lake Analytics account.
  ## 
  let valid = call_564342.validator(path, query, header, formData, body)
  let scheme = call_564342.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564342.url(scheme.get, call_564342.host, call_564342.base,
                         call_564342.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564342, url, valid)

proc call*(call_564343: Call_FirewallRulesListByAccount_564335; apiVersion: string;
          subscriptionId: string; resourceGroupName: string; accountName: string): Recallable =
  ## firewallRulesListByAccount
  ## Lists the Data Lake Analytics firewall rules within the specified Data Lake Analytics account.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Get subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the Azure resource group.
  ##   accountName: string (required)
  ##              : The name of the Data Lake Analytics account.
  var path_564344 = newJObject()
  var query_564345 = newJObject()
  add(query_564345, "api-version", newJString(apiVersion))
  add(path_564344, "subscriptionId", newJString(subscriptionId))
  add(path_564344, "resourceGroupName", newJString(resourceGroupName))
  add(path_564344, "accountName", newJString(accountName))
  result = call_564343.call(path_564344, query_564345, nil, nil, nil)

var firewallRulesListByAccount* = Call_FirewallRulesListByAccount_564335(
    name: "firewallRulesListByAccount", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataLakeAnalytics/accounts/{accountName}/firewallRules",
    validator: validate_FirewallRulesListByAccount_564336, base: "",
    url: url_FirewallRulesListByAccount_564337, schemes: {Scheme.Https})
type
  Call_FirewallRulesCreateOrUpdate_564358 = ref object of OpenApiRestCall_563564
proc url_FirewallRulesCreateOrUpdate_564360(protocol: Scheme; host: string;
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

proc validate_FirewallRulesCreateOrUpdate_564359(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates or updates the specified firewall rule. During update, the firewall rule with the specified name will be replaced with this new firewall rule.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   firewallRuleName: JString (required)
  ##                   : The name of the firewall rule to create or update.
  ##   subscriptionId: JString (required)
  ##                 : Get subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the Azure resource group.
  ##   accountName: JString (required)
  ##              : The name of the Data Lake Analytics account.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `firewallRuleName` field"
  var valid_564361 = path.getOrDefault("firewallRuleName")
  valid_564361 = validateParameter(valid_564361, JString, required = true,
                                 default = nil)
  if valid_564361 != nil:
    section.add "firewallRuleName", valid_564361
  var valid_564362 = path.getOrDefault("subscriptionId")
  valid_564362 = validateParameter(valid_564362, JString, required = true,
                                 default = nil)
  if valid_564362 != nil:
    section.add "subscriptionId", valid_564362
  var valid_564363 = path.getOrDefault("resourceGroupName")
  valid_564363 = validateParameter(valid_564363, JString, required = true,
                                 default = nil)
  if valid_564363 != nil:
    section.add "resourceGroupName", valid_564363
  var valid_564364 = path.getOrDefault("accountName")
  valid_564364 = validateParameter(valid_564364, JString, required = true,
                                 default = nil)
  if valid_564364 != nil:
    section.add "accountName", valid_564364
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564365 = query.getOrDefault("api-version")
  valid_564365 = validateParameter(valid_564365, JString, required = true,
                                 default = nil)
  if valid_564365 != nil:
    section.add "api-version", valid_564365
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

proc call*(call_564367: Call_FirewallRulesCreateOrUpdate_564358; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates or updates the specified firewall rule. During update, the firewall rule with the specified name will be replaced with this new firewall rule.
  ## 
  let valid = call_564367.validator(path, query, header, formData, body)
  let scheme = call_564367.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564367.url(scheme.get, call_564367.host, call_564367.base,
                         call_564367.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564367, url, valid)

proc call*(call_564368: Call_FirewallRulesCreateOrUpdate_564358;
          apiVersion: string; firewallRuleName: string; subscriptionId: string;
          resourceGroupName: string; parameters: JsonNode; accountName: string): Recallable =
  ## firewallRulesCreateOrUpdate
  ## Creates or updates the specified firewall rule. During update, the firewall rule with the specified name will be replaced with this new firewall rule.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   firewallRuleName: string (required)
  ##                   : The name of the firewall rule to create or update.
  ##   subscriptionId: string (required)
  ##                 : Get subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the Azure resource group.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to create or update the firewall rule.
  ##   accountName: string (required)
  ##              : The name of the Data Lake Analytics account.
  var path_564369 = newJObject()
  var query_564370 = newJObject()
  var body_564371 = newJObject()
  add(query_564370, "api-version", newJString(apiVersion))
  add(path_564369, "firewallRuleName", newJString(firewallRuleName))
  add(path_564369, "subscriptionId", newJString(subscriptionId))
  add(path_564369, "resourceGroupName", newJString(resourceGroupName))
  if parameters != nil:
    body_564371 = parameters
  add(path_564369, "accountName", newJString(accountName))
  result = call_564368.call(path_564369, query_564370, nil, nil, body_564371)

var firewallRulesCreateOrUpdate* = Call_FirewallRulesCreateOrUpdate_564358(
    name: "firewallRulesCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataLakeAnalytics/accounts/{accountName}/firewallRules/{firewallRuleName}",
    validator: validate_FirewallRulesCreateOrUpdate_564359, base: "",
    url: url_FirewallRulesCreateOrUpdate_564360, schemes: {Scheme.Https})
type
  Call_FirewallRulesGet_564346 = ref object of OpenApiRestCall_563564
proc url_FirewallRulesGet_564348(protocol: Scheme; host: string; base: string;
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

proc validate_FirewallRulesGet_564347(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Gets the specified Data Lake Analytics firewall rule.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   firewallRuleName: JString (required)
  ##                   : The name of the firewall rule to retrieve.
  ##   subscriptionId: JString (required)
  ##                 : Get subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the Azure resource group.
  ##   accountName: JString (required)
  ##              : The name of the Data Lake Analytics account.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `firewallRuleName` field"
  var valid_564349 = path.getOrDefault("firewallRuleName")
  valid_564349 = validateParameter(valid_564349, JString, required = true,
                                 default = nil)
  if valid_564349 != nil:
    section.add "firewallRuleName", valid_564349
  var valid_564350 = path.getOrDefault("subscriptionId")
  valid_564350 = validateParameter(valid_564350, JString, required = true,
                                 default = nil)
  if valid_564350 != nil:
    section.add "subscriptionId", valid_564350
  var valid_564351 = path.getOrDefault("resourceGroupName")
  valid_564351 = validateParameter(valid_564351, JString, required = true,
                                 default = nil)
  if valid_564351 != nil:
    section.add "resourceGroupName", valid_564351
  var valid_564352 = path.getOrDefault("accountName")
  valid_564352 = validateParameter(valid_564352, JString, required = true,
                                 default = nil)
  if valid_564352 != nil:
    section.add "accountName", valid_564352
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564353 = query.getOrDefault("api-version")
  valid_564353 = validateParameter(valid_564353, JString, required = true,
                                 default = nil)
  if valid_564353 != nil:
    section.add "api-version", valid_564353
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564354: Call_FirewallRulesGet_564346; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the specified Data Lake Analytics firewall rule.
  ## 
  let valid = call_564354.validator(path, query, header, formData, body)
  let scheme = call_564354.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564354.url(scheme.get, call_564354.host, call_564354.base,
                         call_564354.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564354, url, valid)

proc call*(call_564355: Call_FirewallRulesGet_564346; apiVersion: string;
          firewallRuleName: string; subscriptionId: string;
          resourceGroupName: string; accountName: string): Recallable =
  ## firewallRulesGet
  ## Gets the specified Data Lake Analytics firewall rule.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   firewallRuleName: string (required)
  ##                   : The name of the firewall rule to retrieve.
  ##   subscriptionId: string (required)
  ##                 : Get subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the Azure resource group.
  ##   accountName: string (required)
  ##              : The name of the Data Lake Analytics account.
  var path_564356 = newJObject()
  var query_564357 = newJObject()
  add(query_564357, "api-version", newJString(apiVersion))
  add(path_564356, "firewallRuleName", newJString(firewallRuleName))
  add(path_564356, "subscriptionId", newJString(subscriptionId))
  add(path_564356, "resourceGroupName", newJString(resourceGroupName))
  add(path_564356, "accountName", newJString(accountName))
  result = call_564355.call(path_564356, query_564357, nil, nil, nil)

var firewallRulesGet* = Call_FirewallRulesGet_564346(name: "firewallRulesGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataLakeAnalytics/accounts/{accountName}/firewallRules/{firewallRuleName}",
    validator: validate_FirewallRulesGet_564347, base: "",
    url: url_FirewallRulesGet_564348, schemes: {Scheme.Https})
type
  Call_FirewallRulesUpdate_564384 = ref object of OpenApiRestCall_563564
proc url_FirewallRulesUpdate_564386(protocol: Scheme; host: string; base: string;
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

proc validate_FirewallRulesUpdate_564385(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Updates the specified firewall rule.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   firewallRuleName: JString (required)
  ##                   : The name of the firewall rule to update.
  ##   subscriptionId: JString (required)
  ##                 : Get subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the Azure resource group.
  ##   accountName: JString (required)
  ##              : The name of the Data Lake Analytics account.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `firewallRuleName` field"
  var valid_564387 = path.getOrDefault("firewallRuleName")
  valid_564387 = validateParameter(valid_564387, JString, required = true,
                                 default = nil)
  if valid_564387 != nil:
    section.add "firewallRuleName", valid_564387
  var valid_564388 = path.getOrDefault("subscriptionId")
  valid_564388 = validateParameter(valid_564388, JString, required = true,
                                 default = nil)
  if valid_564388 != nil:
    section.add "subscriptionId", valid_564388
  var valid_564389 = path.getOrDefault("resourceGroupName")
  valid_564389 = validateParameter(valid_564389, JString, required = true,
                                 default = nil)
  if valid_564389 != nil:
    section.add "resourceGroupName", valid_564389
  var valid_564390 = path.getOrDefault("accountName")
  valid_564390 = validateParameter(valid_564390, JString, required = true,
                                 default = nil)
  if valid_564390 != nil:
    section.add "accountName", valid_564390
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564391 = query.getOrDefault("api-version")
  valid_564391 = validateParameter(valid_564391, JString, required = true,
                                 default = nil)
  if valid_564391 != nil:
    section.add "api-version", valid_564391
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

proc call*(call_564393: Call_FirewallRulesUpdate_564384; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the specified firewall rule.
  ## 
  let valid = call_564393.validator(path, query, header, formData, body)
  let scheme = call_564393.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564393.url(scheme.get, call_564393.host, call_564393.base,
                         call_564393.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564393, url, valid)

proc call*(call_564394: Call_FirewallRulesUpdate_564384; apiVersion: string;
          firewallRuleName: string; subscriptionId: string;
          resourceGroupName: string; accountName: string; parameters: JsonNode = nil): Recallable =
  ## firewallRulesUpdate
  ## Updates the specified firewall rule.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   firewallRuleName: string (required)
  ##                   : The name of the firewall rule to update.
  ##   subscriptionId: string (required)
  ##                 : Get subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the Azure resource group.
  ##   parameters: JObject
  ##             : Parameters supplied to update the firewall rule.
  ##   accountName: string (required)
  ##              : The name of the Data Lake Analytics account.
  var path_564395 = newJObject()
  var query_564396 = newJObject()
  var body_564397 = newJObject()
  add(query_564396, "api-version", newJString(apiVersion))
  add(path_564395, "firewallRuleName", newJString(firewallRuleName))
  add(path_564395, "subscriptionId", newJString(subscriptionId))
  add(path_564395, "resourceGroupName", newJString(resourceGroupName))
  if parameters != nil:
    body_564397 = parameters
  add(path_564395, "accountName", newJString(accountName))
  result = call_564394.call(path_564395, query_564396, nil, nil, body_564397)

var firewallRulesUpdate* = Call_FirewallRulesUpdate_564384(
    name: "firewallRulesUpdate", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataLakeAnalytics/accounts/{accountName}/firewallRules/{firewallRuleName}",
    validator: validate_FirewallRulesUpdate_564385, base: "",
    url: url_FirewallRulesUpdate_564386, schemes: {Scheme.Https})
type
  Call_FirewallRulesDelete_564372 = ref object of OpenApiRestCall_563564
proc url_FirewallRulesDelete_564374(protocol: Scheme; host: string; base: string;
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

proc validate_FirewallRulesDelete_564373(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Deletes the specified firewall rule from the specified Data Lake Analytics account
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   firewallRuleName: JString (required)
  ##                   : The name of the firewall rule to delete.
  ##   subscriptionId: JString (required)
  ##                 : Get subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the Azure resource group.
  ##   accountName: JString (required)
  ##              : The name of the Data Lake Analytics account.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `firewallRuleName` field"
  var valid_564375 = path.getOrDefault("firewallRuleName")
  valid_564375 = validateParameter(valid_564375, JString, required = true,
                                 default = nil)
  if valid_564375 != nil:
    section.add "firewallRuleName", valid_564375
  var valid_564376 = path.getOrDefault("subscriptionId")
  valid_564376 = validateParameter(valid_564376, JString, required = true,
                                 default = nil)
  if valid_564376 != nil:
    section.add "subscriptionId", valid_564376
  var valid_564377 = path.getOrDefault("resourceGroupName")
  valid_564377 = validateParameter(valid_564377, JString, required = true,
                                 default = nil)
  if valid_564377 != nil:
    section.add "resourceGroupName", valid_564377
  var valid_564378 = path.getOrDefault("accountName")
  valid_564378 = validateParameter(valid_564378, JString, required = true,
                                 default = nil)
  if valid_564378 != nil:
    section.add "accountName", valid_564378
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564379 = query.getOrDefault("api-version")
  valid_564379 = validateParameter(valid_564379, JString, required = true,
                                 default = nil)
  if valid_564379 != nil:
    section.add "api-version", valid_564379
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564380: Call_FirewallRulesDelete_564372; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the specified firewall rule from the specified Data Lake Analytics account
  ## 
  let valid = call_564380.validator(path, query, header, formData, body)
  let scheme = call_564380.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564380.url(scheme.get, call_564380.host, call_564380.base,
                         call_564380.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564380, url, valid)

proc call*(call_564381: Call_FirewallRulesDelete_564372; apiVersion: string;
          firewallRuleName: string; subscriptionId: string;
          resourceGroupName: string; accountName: string): Recallable =
  ## firewallRulesDelete
  ## Deletes the specified firewall rule from the specified Data Lake Analytics account
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   firewallRuleName: string (required)
  ##                   : The name of the firewall rule to delete.
  ##   subscriptionId: string (required)
  ##                 : Get subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the Azure resource group.
  ##   accountName: string (required)
  ##              : The name of the Data Lake Analytics account.
  var path_564382 = newJObject()
  var query_564383 = newJObject()
  add(query_564383, "api-version", newJString(apiVersion))
  add(path_564382, "firewallRuleName", newJString(firewallRuleName))
  add(path_564382, "subscriptionId", newJString(subscriptionId))
  add(path_564382, "resourceGroupName", newJString(resourceGroupName))
  add(path_564382, "accountName", newJString(accountName))
  result = call_564381.call(path_564382, query_564383, nil, nil, nil)

var firewallRulesDelete* = Call_FirewallRulesDelete_564372(
    name: "firewallRulesDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataLakeAnalytics/accounts/{accountName}/firewallRules/{firewallRuleName}",
    validator: validate_FirewallRulesDelete_564373, base: "",
    url: url_FirewallRulesDelete_564374, schemes: {Scheme.Https})
type
  Call_StorageAccountsListByAccount_564398 = ref object of OpenApiRestCall_563564
proc url_StorageAccountsListByAccount_564400(protocol: Scheme; host: string;
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

proc validate_StorageAccountsListByAccount_564399(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the first page of Azure Storage accounts, if any, linked to the specified Data Lake Analytics account. The response includes a link to the next page, if any.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Get subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the Azure resource group.
  ##   accountName: JString (required)
  ##              : The name of the Data Lake Analytics account.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564401 = path.getOrDefault("subscriptionId")
  valid_564401 = validateParameter(valid_564401, JString, required = true,
                                 default = nil)
  if valid_564401 != nil:
    section.add "subscriptionId", valid_564401
  var valid_564402 = path.getOrDefault("resourceGroupName")
  valid_564402 = validateParameter(valid_564402, JString, required = true,
                                 default = nil)
  if valid_564402 != nil:
    section.add "resourceGroupName", valid_564402
  var valid_564403 = path.getOrDefault("accountName")
  valid_564403 = validateParameter(valid_564403, JString, required = true,
                                 default = nil)
  if valid_564403 != nil:
    section.add "accountName", valid_564403
  result.add "path", section
  ## parameters in `query` object:
  ##   $top: JInt
  ##       : The number of items to return. Optional.
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   $select: JString
  ##          : OData Select statement. Limits the properties on each entry to just those requested, e.g. Categories?$select=CategoryName,Description. Optional.
  ##   $count: JBool
  ##         : The Boolean value of true or false to request a count of the matching resources included with the resources in the response, e.g. Categories?$count=true. Optional.
  ##   $orderby: JString
  ##           : OrderBy clause. One or more comma-separated expressions with an optional "asc" (the default) or "desc" depending on the order you'd like the values sorted, e.g. Categories?$orderby=CategoryName desc. Optional.
  ##   $skip: JInt
  ##        : The number of items to skip over before returning elements. Optional.
  ##   $filter: JString
  ##          : The OData filter. Optional.
  section = newJObject()
  var valid_564404 = query.getOrDefault("$top")
  valid_564404 = validateParameter(valid_564404, JInt, required = false, default = nil)
  if valid_564404 != nil:
    section.add "$top", valid_564404
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564405 = query.getOrDefault("api-version")
  valid_564405 = validateParameter(valid_564405, JString, required = true,
                                 default = nil)
  if valid_564405 != nil:
    section.add "api-version", valid_564405
  var valid_564406 = query.getOrDefault("$select")
  valid_564406 = validateParameter(valid_564406, JString, required = false,
                                 default = nil)
  if valid_564406 != nil:
    section.add "$select", valid_564406
  var valid_564407 = query.getOrDefault("$count")
  valid_564407 = validateParameter(valid_564407, JBool, required = false, default = nil)
  if valid_564407 != nil:
    section.add "$count", valid_564407
  var valid_564408 = query.getOrDefault("$orderby")
  valid_564408 = validateParameter(valid_564408, JString, required = false,
                                 default = nil)
  if valid_564408 != nil:
    section.add "$orderby", valid_564408
  var valid_564409 = query.getOrDefault("$skip")
  valid_564409 = validateParameter(valid_564409, JInt, required = false, default = nil)
  if valid_564409 != nil:
    section.add "$skip", valid_564409
  var valid_564410 = query.getOrDefault("$filter")
  valid_564410 = validateParameter(valid_564410, JString, required = false,
                                 default = nil)
  if valid_564410 != nil:
    section.add "$filter", valid_564410
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564411: Call_StorageAccountsListByAccount_564398; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the first page of Azure Storage accounts, if any, linked to the specified Data Lake Analytics account. The response includes a link to the next page, if any.
  ## 
  let valid = call_564411.validator(path, query, header, formData, body)
  let scheme = call_564411.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564411.url(scheme.get, call_564411.host, call_564411.base,
                         call_564411.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564411, url, valid)

proc call*(call_564412: Call_StorageAccountsListByAccount_564398;
          apiVersion: string; subscriptionId: string; resourceGroupName: string;
          accountName: string; Top: int = 0; Select: string = ""; Count: bool = false;
          Orderby: string = ""; Skip: int = 0; Filter: string = ""): Recallable =
  ## storageAccountsListByAccount
  ## Gets the first page of Azure Storage accounts, if any, linked to the specified Data Lake Analytics account. The response includes a link to the next page, if any.
  ##   Top: int
  ##      : The number of items to return. Optional.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   Select: string
  ##         : OData Select statement. Limits the properties on each entry to just those requested, e.g. Categories?$select=CategoryName,Description. Optional.
  ##   Count: bool
  ##        : The Boolean value of true or false to request a count of the matching resources included with the resources in the response, e.g. Categories?$count=true. Optional.
  ##   subscriptionId: string (required)
  ##                 : Get subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   Orderby: string
  ##          : OrderBy clause. One or more comma-separated expressions with an optional "asc" (the default) or "desc" depending on the order you'd like the values sorted, e.g. Categories?$orderby=CategoryName desc. Optional.
  ##   Skip: int
  ##       : The number of items to skip over before returning elements. Optional.
  ##   resourceGroupName: string (required)
  ##                    : The name of the Azure resource group.
  ##   Filter: string
  ##         : The OData filter. Optional.
  ##   accountName: string (required)
  ##              : The name of the Data Lake Analytics account.
  var path_564413 = newJObject()
  var query_564414 = newJObject()
  add(query_564414, "$top", newJInt(Top))
  add(query_564414, "api-version", newJString(apiVersion))
  add(query_564414, "$select", newJString(Select))
  add(query_564414, "$count", newJBool(Count))
  add(path_564413, "subscriptionId", newJString(subscriptionId))
  add(query_564414, "$orderby", newJString(Orderby))
  add(query_564414, "$skip", newJInt(Skip))
  add(path_564413, "resourceGroupName", newJString(resourceGroupName))
  add(query_564414, "$filter", newJString(Filter))
  add(path_564413, "accountName", newJString(accountName))
  result = call_564412.call(path_564413, query_564414, nil, nil, nil)

var storageAccountsListByAccount* = Call_StorageAccountsListByAccount_564398(
    name: "storageAccountsListByAccount", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataLakeAnalytics/accounts/{accountName}/storageAccounts",
    validator: validate_StorageAccountsListByAccount_564399, base: "",
    url: url_StorageAccountsListByAccount_564400, schemes: {Scheme.Https})
type
  Call_StorageAccountsAdd_564427 = ref object of OpenApiRestCall_563564
proc url_StorageAccountsAdd_564429(protocol: Scheme; host: string; base: string;
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

proc validate_StorageAccountsAdd_564428(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Updates the specified Data Lake Analytics account to add an Azure Storage account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Get subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the Azure resource group.
  ##   storageAccountName: JString (required)
  ##                     : The name of the Azure Storage account to add
  ##   accountName: JString (required)
  ##              : The name of the Data Lake Analytics account.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564430 = path.getOrDefault("subscriptionId")
  valid_564430 = validateParameter(valid_564430, JString, required = true,
                                 default = nil)
  if valid_564430 != nil:
    section.add "subscriptionId", valid_564430
  var valid_564431 = path.getOrDefault("resourceGroupName")
  valid_564431 = validateParameter(valid_564431, JString, required = true,
                                 default = nil)
  if valid_564431 != nil:
    section.add "resourceGroupName", valid_564431
  var valid_564432 = path.getOrDefault("storageAccountName")
  valid_564432 = validateParameter(valid_564432, JString, required = true,
                                 default = nil)
  if valid_564432 != nil:
    section.add "storageAccountName", valid_564432
  var valid_564433 = path.getOrDefault("accountName")
  valid_564433 = validateParameter(valid_564433, JString, required = true,
                                 default = nil)
  if valid_564433 != nil:
    section.add "accountName", valid_564433
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564434 = query.getOrDefault("api-version")
  valid_564434 = validateParameter(valid_564434, JString, required = true,
                                 default = nil)
  if valid_564434 != nil:
    section.add "api-version", valid_564434
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

proc call*(call_564436: Call_StorageAccountsAdd_564427; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the specified Data Lake Analytics account to add an Azure Storage account.
  ## 
  let valid = call_564436.validator(path, query, header, formData, body)
  let scheme = call_564436.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564436.url(scheme.get, call_564436.host, call_564436.base,
                         call_564436.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564436, url, valid)

proc call*(call_564437: Call_StorageAccountsAdd_564427; apiVersion: string;
          subscriptionId: string; resourceGroupName: string;
          storageAccountName: string; parameters: JsonNode; accountName: string): Recallable =
  ## storageAccountsAdd
  ## Updates the specified Data Lake Analytics account to add an Azure Storage account.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Get subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the Azure resource group.
  ##   storageAccountName: string (required)
  ##                     : The name of the Azure Storage account to add
  ##   parameters: JObject (required)
  ##             : The parameters containing the access key and optional suffix for the Azure Storage Account.
  ##   accountName: string (required)
  ##              : The name of the Data Lake Analytics account.
  var path_564438 = newJObject()
  var query_564439 = newJObject()
  var body_564440 = newJObject()
  add(query_564439, "api-version", newJString(apiVersion))
  add(path_564438, "subscriptionId", newJString(subscriptionId))
  add(path_564438, "resourceGroupName", newJString(resourceGroupName))
  add(path_564438, "storageAccountName", newJString(storageAccountName))
  if parameters != nil:
    body_564440 = parameters
  add(path_564438, "accountName", newJString(accountName))
  result = call_564437.call(path_564438, query_564439, nil, nil, body_564440)

var storageAccountsAdd* = Call_StorageAccountsAdd_564427(
    name: "storageAccountsAdd", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataLakeAnalytics/accounts/{accountName}/storageAccounts/{storageAccountName}",
    validator: validate_StorageAccountsAdd_564428, base: "",
    url: url_StorageAccountsAdd_564429, schemes: {Scheme.Https})
type
  Call_StorageAccountsGet_564415 = ref object of OpenApiRestCall_563564
proc url_StorageAccountsGet_564417(protocol: Scheme; host: string; base: string;
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

proc validate_StorageAccountsGet_564416(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Gets the specified Azure Storage account linked to the given Data Lake Analytics account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Get subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the Azure resource group.
  ##   storageAccountName: JString (required)
  ##                     : The name of the Azure Storage account for which to retrieve the details.
  ##   accountName: JString (required)
  ##              : The name of the Data Lake Analytics account.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564418 = path.getOrDefault("subscriptionId")
  valid_564418 = validateParameter(valid_564418, JString, required = true,
                                 default = nil)
  if valid_564418 != nil:
    section.add "subscriptionId", valid_564418
  var valid_564419 = path.getOrDefault("resourceGroupName")
  valid_564419 = validateParameter(valid_564419, JString, required = true,
                                 default = nil)
  if valid_564419 != nil:
    section.add "resourceGroupName", valid_564419
  var valid_564420 = path.getOrDefault("storageAccountName")
  valid_564420 = validateParameter(valid_564420, JString, required = true,
                                 default = nil)
  if valid_564420 != nil:
    section.add "storageAccountName", valid_564420
  var valid_564421 = path.getOrDefault("accountName")
  valid_564421 = validateParameter(valid_564421, JString, required = true,
                                 default = nil)
  if valid_564421 != nil:
    section.add "accountName", valid_564421
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564422 = query.getOrDefault("api-version")
  valid_564422 = validateParameter(valid_564422, JString, required = true,
                                 default = nil)
  if valid_564422 != nil:
    section.add "api-version", valid_564422
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564423: Call_StorageAccountsGet_564415; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the specified Azure Storage account linked to the given Data Lake Analytics account.
  ## 
  let valid = call_564423.validator(path, query, header, formData, body)
  let scheme = call_564423.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564423.url(scheme.get, call_564423.host, call_564423.base,
                         call_564423.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564423, url, valid)

proc call*(call_564424: Call_StorageAccountsGet_564415; apiVersion: string;
          subscriptionId: string; resourceGroupName: string;
          storageAccountName: string; accountName: string): Recallable =
  ## storageAccountsGet
  ## Gets the specified Azure Storage account linked to the given Data Lake Analytics account.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Get subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the Azure resource group.
  ##   storageAccountName: string (required)
  ##                     : The name of the Azure Storage account for which to retrieve the details.
  ##   accountName: string (required)
  ##              : The name of the Data Lake Analytics account.
  var path_564425 = newJObject()
  var query_564426 = newJObject()
  add(query_564426, "api-version", newJString(apiVersion))
  add(path_564425, "subscriptionId", newJString(subscriptionId))
  add(path_564425, "resourceGroupName", newJString(resourceGroupName))
  add(path_564425, "storageAccountName", newJString(storageAccountName))
  add(path_564425, "accountName", newJString(accountName))
  result = call_564424.call(path_564425, query_564426, nil, nil, nil)

var storageAccountsGet* = Call_StorageAccountsGet_564415(
    name: "storageAccountsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataLakeAnalytics/accounts/{accountName}/storageAccounts/{storageAccountName}",
    validator: validate_StorageAccountsGet_564416, base: "",
    url: url_StorageAccountsGet_564417, schemes: {Scheme.Https})
type
  Call_StorageAccountsUpdate_564453 = ref object of OpenApiRestCall_563564
proc url_StorageAccountsUpdate_564455(protocol: Scheme; host: string; base: string;
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

proc validate_StorageAccountsUpdate_564454(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates the Data Lake Analytics account to replace Azure Storage blob account details, such as the access key and/or suffix.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Get subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the Azure resource group.
  ##   storageAccountName: JString (required)
  ##                     : The Azure Storage account to modify
  ##   accountName: JString (required)
  ##              : The name of the Data Lake Analytics account.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564456 = path.getOrDefault("subscriptionId")
  valid_564456 = validateParameter(valid_564456, JString, required = true,
                                 default = nil)
  if valid_564456 != nil:
    section.add "subscriptionId", valid_564456
  var valid_564457 = path.getOrDefault("resourceGroupName")
  valid_564457 = validateParameter(valid_564457, JString, required = true,
                                 default = nil)
  if valid_564457 != nil:
    section.add "resourceGroupName", valid_564457
  var valid_564458 = path.getOrDefault("storageAccountName")
  valid_564458 = validateParameter(valid_564458, JString, required = true,
                                 default = nil)
  if valid_564458 != nil:
    section.add "storageAccountName", valid_564458
  var valid_564459 = path.getOrDefault("accountName")
  valid_564459 = validateParameter(valid_564459, JString, required = true,
                                 default = nil)
  if valid_564459 != nil:
    section.add "accountName", valid_564459
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564460 = query.getOrDefault("api-version")
  valid_564460 = validateParameter(valid_564460, JString, required = true,
                                 default = nil)
  if valid_564460 != nil:
    section.add "api-version", valid_564460
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

proc call*(call_564462: Call_StorageAccountsUpdate_564453; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the Data Lake Analytics account to replace Azure Storage blob account details, such as the access key and/or suffix.
  ## 
  let valid = call_564462.validator(path, query, header, formData, body)
  let scheme = call_564462.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564462.url(scheme.get, call_564462.host, call_564462.base,
                         call_564462.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564462, url, valid)

proc call*(call_564463: Call_StorageAccountsUpdate_564453; apiVersion: string;
          subscriptionId: string; resourceGroupName: string;
          storageAccountName: string; accountName: string;
          parameters: JsonNode = nil): Recallable =
  ## storageAccountsUpdate
  ## Updates the Data Lake Analytics account to replace Azure Storage blob account details, such as the access key and/or suffix.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Get subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the Azure resource group.
  ##   storageAccountName: string (required)
  ##                     : The Azure Storage account to modify
  ##   parameters: JObject
  ##             : The parameters containing the access key and suffix to update the storage account with, if any. Passing nothing results in no change.
  ##   accountName: string (required)
  ##              : The name of the Data Lake Analytics account.
  var path_564464 = newJObject()
  var query_564465 = newJObject()
  var body_564466 = newJObject()
  add(query_564465, "api-version", newJString(apiVersion))
  add(path_564464, "subscriptionId", newJString(subscriptionId))
  add(path_564464, "resourceGroupName", newJString(resourceGroupName))
  add(path_564464, "storageAccountName", newJString(storageAccountName))
  if parameters != nil:
    body_564466 = parameters
  add(path_564464, "accountName", newJString(accountName))
  result = call_564463.call(path_564464, query_564465, nil, nil, body_564466)

var storageAccountsUpdate* = Call_StorageAccountsUpdate_564453(
    name: "storageAccountsUpdate", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataLakeAnalytics/accounts/{accountName}/storageAccounts/{storageAccountName}",
    validator: validate_StorageAccountsUpdate_564454, base: "",
    url: url_StorageAccountsUpdate_564455, schemes: {Scheme.Https})
type
  Call_StorageAccountsDelete_564441 = ref object of OpenApiRestCall_563564
proc url_StorageAccountsDelete_564443(protocol: Scheme; host: string; base: string;
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

proc validate_StorageAccountsDelete_564442(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates the specified Data Lake Analytics account to remove an Azure Storage account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Get subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the Azure resource group.
  ##   storageAccountName: JString (required)
  ##                     : The name of the Azure Storage account to remove
  ##   accountName: JString (required)
  ##              : The name of the Data Lake Analytics account.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564444 = path.getOrDefault("subscriptionId")
  valid_564444 = validateParameter(valid_564444, JString, required = true,
                                 default = nil)
  if valid_564444 != nil:
    section.add "subscriptionId", valid_564444
  var valid_564445 = path.getOrDefault("resourceGroupName")
  valid_564445 = validateParameter(valid_564445, JString, required = true,
                                 default = nil)
  if valid_564445 != nil:
    section.add "resourceGroupName", valid_564445
  var valid_564446 = path.getOrDefault("storageAccountName")
  valid_564446 = validateParameter(valid_564446, JString, required = true,
                                 default = nil)
  if valid_564446 != nil:
    section.add "storageAccountName", valid_564446
  var valid_564447 = path.getOrDefault("accountName")
  valid_564447 = validateParameter(valid_564447, JString, required = true,
                                 default = nil)
  if valid_564447 != nil:
    section.add "accountName", valid_564447
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564448 = query.getOrDefault("api-version")
  valid_564448 = validateParameter(valid_564448, JString, required = true,
                                 default = nil)
  if valid_564448 != nil:
    section.add "api-version", valid_564448
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564449: Call_StorageAccountsDelete_564441; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the specified Data Lake Analytics account to remove an Azure Storage account.
  ## 
  let valid = call_564449.validator(path, query, header, formData, body)
  let scheme = call_564449.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564449.url(scheme.get, call_564449.host, call_564449.base,
                         call_564449.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564449, url, valid)

proc call*(call_564450: Call_StorageAccountsDelete_564441; apiVersion: string;
          subscriptionId: string; resourceGroupName: string;
          storageAccountName: string; accountName: string): Recallable =
  ## storageAccountsDelete
  ## Updates the specified Data Lake Analytics account to remove an Azure Storage account.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Get subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the Azure resource group.
  ##   storageAccountName: string (required)
  ##                     : The name of the Azure Storage account to remove
  ##   accountName: string (required)
  ##              : The name of the Data Lake Analytics account.
  var path_564451 = newJObject()
  var query_564452 = newJObject()
  add(query_564452, "api-version", newJString(apiVersion))
  add(path_564451, "subscriptionId", newJString(subscriptionId))
  add(path_564451, "resourceGroupName", newJString(resourceGroupName))
  add(path_564451, "storageAccountName", newJString(storageAccountName))
  add(path_564451, "accountName", newJString(accountName))
  result = call_564450.call(path_564451, query_564452, nil, nil, nil)

var storageAccountsDelete* = Call_StorageAccountsDelete_564441(
    name: "storageAccountsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataLakeAnalytics/accounts/{accountName}/storageAccounts/{storageAccountName}",
    validator: validate_StorageAccountsDelete_564442, base: "",
    url: url_StorageAccountsDelete_564443, schemes: {Scheme.Https})
type
  Call_StorageAccountsListStorageContainers_564467 = ref object of OpenApiRestCall_563564
proc url_StorageAccountsListStorageContainers_564469(protocol: Scheme;
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

proc validate_StorageAccountsListStorageContainers_564468(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists the Azure Storage containers, if any, associated with the specified Data Lake Analytics and Azure Storage account combination. The response includes a link to the next page of results, if any.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Get subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the Azure resource group.
  ##   storageAccountName: JString (required)
  ##                     : The name of the Azure storage account from which to list blob containers.
  ##   accountName: JString (required)
  ##              : The name of the Data Lake Analytics account.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564470 = path.getOrDefault("subscriptionId")
  valid_564470 = validateParameter(valid_564470, JString, required = true,
                                 default = nil)
  if valid_564470 != nil:
    section.add "subscriptionId", valid_564470
  var valid_564471 = path.getOrDefault("resourceGroupName")
  valid_564471 = validateParameter(valid_564471, JString, required = true,
                                 default = nil)
  if valid_564471 != nil:
    section.add "resourceGroupName", valid_564471
  var valid_564472 = path.getOrDefault("storageAccountName")
  valid_564472 = validateParameter(valid_564472, JString, required = true,
                                 default = nil)
  if valid_564472 != nil:
    section.add "storageAccountName", valid_564472
  var valid_564473 = path.getOrDefault("accountName")
  valid_564473 = validateParameter(valid_564473, JString, required = true,
                                 default = nil)
  if valid_564473 != nil:
    section.add "accountName", valid_564473
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564474 = query.getOrDefault("api-version")
  valid_564474 = validateParameter(valid_564474, JString, required = true,
                                 default = nil)
  if valid_564474 != nil:
    section.add "api-version", valid_564474
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564475: Call_StorageAccountsListStorageContainers_564467;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the Azure Storage containers, if any, associated with the specified Data Lake Analytics and Azure Storage account combination. The response includes a link to the next page of results, if any.
  ## 
  let valid = call_564475.validator(path, query, header, formData, body)
  let scheme = call_564475.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564475.url(scheme.get, call_564475.host, call_564475.base,
                         call_564475.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564475, url, valid)

proc call*(call_564476: Call_StorageAccountsListStorageContainers_564467;
          apiVersion: string; subscriptionId: string; resourceGroupName: string;
          storageAccountName: string; accountName: string): Recallable =
  ## storageAccountsListStorageContainers
  ## Lists the Azure Storage containers, if any, associated with the specified Data Lake Analytics and Azure Storage account combination. The response includes a link to the next page of results, if any.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Get subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the Azure resource group.
  ##   storageAccountName: string (required)
  ##                     : The name of the Azure storage account from which to list blob containers.
  ##   accountName: string (required)
  ##              : The name of the Data Lake Analytics account.
  var path_564477 = newJObject()
  var query_564478 = newJObject()
  add(query_564478, "api-version", newJString(apiVersion))
  add(path_564477, "subscriptionId", newJString(subscriptionId))
  add(path_564477, "resourceGroupName", newJString(resourceGroupName))
  add(path_564477, "storageAccountName", newJString(storageAccountName))
  add(path_564477, "accountName", newJString(accountName))
  result = call_564476.call(path_564477, query_564478, nil, nil, nil)

var storageAccountsListStorageContainers* = Call_StorageAccountsListStorageContainers_564467(
    name: "storageAccountsListStorageContainers", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataLakeAnalytics/accounts/{accountName}/storageAccounts/{storageAccountName}/containers",
    validator: validate_StorageAccountsListStorageContainers_564468, base: "",
    url: url_StorageAccountsListStorageContainers_564469, schemes: {Scheme.Https})
type
  Call_StorageAccountsGetStorageContainer_564479 = ref object of OpenApiRestCall_563564
proc url_StorageAccountsGetStorageContainer_564481(protocol: Scheme; host: string;
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

proc validate_StorageAccountsGetStorageContainer_564480(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the specified Azure Storage container associated with the given Data Lake Analytics and Azure Storage accounts.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Get subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the Azure resource group.
  ##   containerName: JString (required)
  ##                : The name of the Azure storage container to retrieve
  ##   storageAccountName: JString (required)
  ##                     : The name of the Azure storage account from which to retrieve the blob container.
  ##   accountName: JString (required)
  ##              : The name of the Data Lake Analytics account.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564482 = path.getOrDefault("subscriptionId")
  valid_564482 = validateParameter(valid_564482, JString, required = true,
                                 default = nil)
  if valid_564482 != nil:
    section.add "subscriptionId", valid_564482
  var valid_564483 = path.getOrDefault("resourceGroupName")
  valid_564483 = validateParameter(valid_564483, JString, required = true,
                                 default = nil)
  if valid_564483 != nil:
    section.add "resourceGroupName", valid_564483
  var valid_564484 = path.getOrDefault("containerName")
  valid_564484 = validateParameter(valid_564484, JString, required = true,
                                 default = nil)
  if valid_564484 != nil:
    section.add "containerName", valid_564484
  var valid_564485 = path.getOrDefault("storageAccountName")
  valid_564485 = validateParameter(valid_564485, JString, required = true,
                                 default = nil)
  if valid_564485 != nil:
    section.add "storageAccountName", valid_564485
  var valid_564486 = path.getOrDefault("accountName")
  valid_564486 = validateParameter(valid_564486, JString, required = true,
                                 default = nil)
  if valid_564486 != nil:
    section.add "accountName", valid_564486
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564487 = query.getOrDefault("api-version")
  valid_564487 = validateParameter(valid_564487, JString, required = true,
                                 default = nil)
  if valid_564487 != nil:
    section.add "api-version", valid_564487
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564488: Call_StorageAccountsGetStorageContainer_564479;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the specified Azure Storage container associated with the given Data Lake Analytics and Azure Storage accounts.
  ## 
  let valid = call_564488.validator(path, query, header, formData, body)
  let scheme = call_564488.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564488.url(scheme.get, call_564488.host, call_564488.base,
                         call_564488.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564488, url, valid)

proc call*(call_564489: Call_StorageAccountsGetStorageContainer_564479;
          apiVersion: string; subscriptionId: string; resourceGroupName: string;
          containerName: string; storageAccountName: string; accountName: string): Recallable =
  ## storageAccountsGetStorageContainer
  ## Gets the specified Azure Storage container associated with the given Data Lake Analytics and Azure Storage accounts.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Get subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the Azure resource group.
  ##   containerName: string (required)
  ##                : The name of the Azure storage container to retrieve
  ##   storageAccountName: string (required)
  ##                     : The name of the Azure storage account from which to retrieve the blob container.
  ##   accountName: string (required)
  ##              : The name of the Data Lake Analytics account.
  var path_564490 = newJObject()
  var query_564491 = newJObject()
  add(query_564491, "api-version", newJString(apiVersion))
  add(path_564490, "subscriptionId", newJString(subscriptionId))
  add(path_564490, "resourceGroupName", newJString(resourceGroupName))
  add(path_564490, "containerName", newJString(containerName))
  add(path_564490, "storageAccountName", newJString(storageAccountName))
  add(path_564490, "accountName", newJString(accountName))
  result = call_564489.call(path_564490, query_564491, nil, nil, nil)

var storageAccountsGetStorageContainer* = Call_StorageAccountsGetStorageContainer_564479(
    name: "storageAccountsGetStorageContainer", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataLakeAnalytics/accounts/{accountName}/storageAccounts/{storageAccountName}/containers/{containerName}",
    validator: validate_StorageAccountsGetStorageContainer_564480, base: "",
    url: url_StorageAccountsGetStorageContainer_564481, schemes: {Scheme.Https})
type
  Call_StorageAccountsListSasTokens_564492 = ref object of OpenApiRestCall_563564
proc url_StorageAccountsListSasTokens_564494(protocol: Scheme; host: string;
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

proc validate_StorageAccountsListSasTokens_564493(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the SAS token associated with the specified Data Lake Analytics and Azure Storage account and container combination.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Get subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the Azure resource group.
  ##   containerName: JString (required)
  ##                : The name of the Azure storage container for which the SAS token is being requested.
  ##   storageAccountName: JString (required)
  ##                     : The name of the Azure storage account for which the SAS token is being requested.
  ##   accountName: JString (required)
  ##              : The name of the Data Lake Analytics account.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564495 = path.getOrDefault("subscriptionId")
  valid_564495 = validateParameter(valid_564495, JString, required = true,
                                 default = nil)
  if valid_564495 != nil:
    section.add "subscriptionId", valid_564495
  var valid_564496 = path.getOrDefault("resourceGroupName")
  valid_564496 = validateParameter(valid_564496, JString, required = true,
                                 default = nil)
  if valid_564496 != nil:
    section.add "resourceGroupName", valid_564496
  var valid_564497 = path.getOrDefault("containerName")
  valid_564497 = validateParameter(valid_564497, JString, required = true,
                                 default = nil)
  if valid_564497 != nil:
    section.add "containerName", valid_564497
  var valid_564498 = path.getOrDefault("storageAccountName")
  valid_564498 = validateParameter(valid_564498, JString, required = true,
                                 default = nil)
  if valid_564498 != nil:
    section.add "storageAccountName", valid_564498
  var valid_564499 = path.getOrDefault("accountName")
  valid_564499 = validateParameter(valid_564499, JString, required = true,
                                 default = nil)
  if valid_564499 != nil:
    section.add "accountName", valid_564499
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564500 = query.getOrDefault("api-version")
  valid_564500 = validateParameter(valid_564500, JString, required = true,
                                 default = nil)
  if valid_564500 != nil:
    section.add "api-version", valid_564500
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564501: Call_StorageAccountsListSasTokens_564492; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the SAS token associated with the specified Data Lake Analytics and Azure Storage account and container combination.
  ## 
  let valid = call_564501.validator(path, query, header, formData, body)
  let scheme = call_564501.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564501.url(scheme.get, call_564501.host, call_564501.base,
                         call_564501.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564501, url, valid)

proc call*(call_564502: Call_StorageAccountsListSasTokens_564492;
          apiVersion: string; subscriptionId: string; resourceGroupName: string;
          containerName: string; storageAccountName: string; accountName: string): Recallable =
  ## storageAccountsListSasTokens
  ## Gets the SAS token associated with the specified Data Lake Analytics and Azure Storage account and container combination.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Get subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the Azure resource group.
  ##   containerName: string (required)
  ##                : The name of the Azure storage container for which the SAS token is being requested.
  ##   storageAccountName: string (required)
  ##                     : The name of the Azure storage account for which the SAS token is being requested.
  ##   accountName: string (required)
  ##              : The name of the Data Lake Analytics account.
  var path_564503 = newJObject()
  var query_564504 = newJObject()
  add(query_564504, "api-version", newJString(apiVersion))
  add(path_564503, "subscriptionId", newJString(subscriptionId))
  add(path_564503, "resourceGroupName", newJString(resourceGroupName))
  add(path_564503, "containerName", newJString(containerName))
  add(path_564503, "storageAccountName", newJString(storageAccountName))
  add(path_564503, "accountName", newJString(accountName))
  result = call_564502.call(path_564503, query_564504, nil, nil, nil)

var storageAccountsListSasTokens* = Call_StorageAccountsListSasTokens_564492(
    name: "storageAccountsListSasTokens", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataLakeAnalytics/accounts/{accountName}/storageAccounts/{storageAccountName}/containers/{containerName}/listSasTokens",
    validator: validate_StorageAccountsListSasTokens_564493, base: "",
    url: url_StorageAccountsListSasTokens_564494, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)

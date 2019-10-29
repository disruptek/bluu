
import
  json, options, hashes, uri, rest, os, uri, httpcore

## auto-generated via openapi macro
## title: Microsoft NetApp
## version: 2019-07-01
## termsOfService: (not provided)
## license: (not provided)
## 
## Microsoft NetApp Azure Resource Provider specification
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

  OpenApiRestCall_563556 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_563556](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_563556): Option[Scheme] {.used.} =
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
  macServiceName = "netapp"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_OperationsList_563778 = ref object of OpenApiRestCall_563556
proc url_OperationsList_563780(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_OperationsList_563779(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Lists all of the available Microsoft.NetApp Rest API operations
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_563954 = query.getOrDefault("api-version")
  valid_563954 = validateParameter(valid_563954, JString, required = true,
                                 default = newJString("2019-07-01"))
  if valid_563954 != nil:
    section.add "api-version", valid_563954
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_563977: Call_OperationsList_563778; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all of the available Microsoft.NetApp Rest API operations
  ## 
  let valid = call_563977.validator(path, query, header, formData, body)
  let scheme = call_563977.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_563977.url(scheme.get, call_563977.host, call_563977.base,
                         call_563977.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_563977, url, valid)

proc call*(call_564048: Call_OperationsList_563778;
          apiVersion: string = "2019-07-01"): Recallable =
  ## operationsList
  ## Lists all of the available Microsoft.NetApp Rest API operations
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  var query_564049 = newJObject()
  add(query_564049, "api-version", newJString(apiVersion))
  result = call_564048.call(nil, query_564049, nil, nil, nil)

var operationsList* = Call_OperationsList_563778(name: "operationsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com",
    route: "/providers/Microsoft.NetApp/operations",
    validator: validate_OperationsList_563779, base: "", url: url_OperationsList_563780,
    schemes: {Scheme.Https})
type
  Call_CheckFilePathAvailability_564089 = ref object of OpenApiRestCall_563556
proc url_CheckFilePathAvailability_564091(protocol: Scheme; host: string;
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
        kind: ConstantSegment, value: "/providers/Microsoft.NetApp/locations/"),
               (kind: VariableSegment, value: "location"),
               (kind: ConstantSegment, value: "/checkFilePathAvailability")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CheckFilePathAvailability_564090(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Check if a file path is available.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   location: JString (required)
  ##           : The location
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564106 = path.getOrDefault("subscriptionId")
  valid_564106 = validateParameter(valid_564106, JString, required = true,
                                 default = nil)
  if valid_564106 != nil:
    section.add "subscriptionId", valid_564106
  var valid_564107 = path.getOrDefault("location")
  valid_564107 = validateParameter(valid_564107, JString, required = true,
                                 default = nil)
  if valid_564107 != nil:
    section.add "location", valid_564107
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564108 = query.getOrDefault("api-version")
  valid_564108 = validateParameter(valid_564108, JString, required = true,
                                 default = newJString("2019-07-01"))
  if valid_564108 != nil:
    section.add "api-version", valid_564108
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject (required)
  ##       : File path availability request.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564110: Call_CheckFilePathAvailability_564089; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Check if a file path is available.
  ## 
  let valid = call_564110.validator(path, query, header, formData, body)
  let scheme = call_564110.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564110.url(scheme.get, call_564110.host, call_564110.base,
                         call_564110.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564110, url, valid)

proc call*(call_564111: Call_CheckFilePathAvailability_564089;
          subscriptionId: string; location: string; body: JsonNode;
          apiVersion: string = "2019-07-01"): Recallable =
  ## checkFilePathAvailability
  ## Check if a file path is available.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   location: string (required)
  ##           : The location
  ##   body: JObject (required)
  ##       : File path availability request.
  var path_564112 = newJObject()
  var query_564113 = newJObject()
  var body_564114 = newJObject()
  add(query_564113, "api-version", newJString(apiVersion))
  add(path_564112, "subscriptionId", newJString(subscriptionId))
  add(path_564112, "location", newJString(location))
  if body != nil:
    body_564114 = body
  result = call_564111.call(path_564112, query_564113, nil, nil, body_564114)

var checkFilePathAvailability* = Call_CheckFilePathAvailability_564089(
    name: "checkFilePathAvailability", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.NetApp/locations/{location}/checkFilePathAvailability",
    validator: validate_CheckFilePathAvailability_564090, base: "",
    url: url_CheckFilePathAvailability_564091, schemes: {Scheme.Https})
type
  Call_CheckNameAvailability_564115 = ref object of OpenApiRestCall_563556
proc url_CheckNameAvailability_564117(protocol: Scheme; host: string; base: string;
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
        kind: ConstantSegment, value: "/providers/Microsoft.NetApp/locations/"),
               (kind: VariableSegment, value: "location"),
               (kind: ConstantSegment, value: "/checkNameAvailability")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CheckNameAvailability_564116(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Check if a resource name is available.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   location: JString (required)
  ##           : The location
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564118 = path.getOrDefault("subscriptionId")
  valid_564118 = validateParameter(valid_564118, JString, required = true,
                                 default = nil)
  if valid_564118 != nil:
    section.add "subscriptionId", valid_564118
  var valid_564119 = path.getOrDefault("location")
  valid_564119 = validateParameter(valid_564119, JString, required = true,
                                 default = nil)
  if valid_564119 != nil:
    section.add "location", valid_564119
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564120 = query.getOrDefault("api-version")
  valid_564120 = validateParameter(valid_564120, JString, required = true,
                                 default = newJString("2019-07-01"))
  if valid_564120 != nil:
    section.add "api-version", valid_564120
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject (required)
  ##       : Name availability request.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564122: Call_CheckNameAvailability_564115; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Check if a resource name is available.
  ## 
  let valid = call_564122.validator(path, query, header, formData, body)
  let scheme = call_564122.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564122.url(scheme.get, call_564122.host, call_564122.base,
                         call_564122.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564122, url, valid)

proc call*(call_564123: Call_CheckNameAvailability_564115; subscriptionId: string;
          location: string; body: JsonNode; apiVersion: string = "2019-07-01"): Recallable =
  ## checkNameAvailability
  ## Check if a resource name is available.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   location: string (required)
  ##           : The location
  ##   body: JObject (required)
  ##       : Name availability request.
  var path_564124 = newJObject()
  var query_564125 = newJObject()
  var body_564126 = newJObject()
  add(query_564125, "api-version", newJString(apiVersion))
  add(path_564124, "subscriptionId", newJString(subscriptionId))
  add(path_564124, "location", newJString(location))
  if body != nil:
    body_564126 = body
  result = call_564123.call(path_564124, query_564125, nil, nil, body_564126)

var checkNameAvailability* = Call_CheckNameAvailability_564115(
    name: "checkNameAvailability", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.NetApp/locations/{location}/checkNameAvailability",
    validator: validate_CheckNameAvailability_564116, base: "",
    url: url_CheckNameAvailability_564117, schemes: {Scheme.Https})
type
  Call_AccountsList_564127 = ref object of OpenApiRestCall_563556
proc url_AccountsList_564129(protocol: Scheme; host: string; base: string;
                            route: string; path: JsonNode; query: JsonNode): Uri =
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
        kind: ConstantSegment, value: "/providers/Microsoft.NetApp/netAppAccounts")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AccountsList_564128(path: JsonNode; query: JsonNode; header: JsonNode;
                                 formData: JsonNode; body: JsonNode): JsonNode =
  ## List and describe all NetApp accounts in the resource group
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564130 = path.getOrDefault("subscriptionId")
  valid_564130 = validateParameter(valid_564130, JString, required = true,
                                 default = nil)
  if valid_564130 != nil:
    section.add "subscriptionId", valid_564130
  var valid_564131 = path.getOrDefault("resourceGroupName")
  valid_564131 = validateParameter(valid_564131, JString, required = true,
                                 default = nil)
  if valid_564131 != nil:
    section.add "resourceGroupName", valid_564131
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564132 = query.getOrDefault("api-version")
  valid_564132 = validateParameter(valid_564132, JString, required = true,
                                 default = newJString("2019-07-01"))
  if valid_564132 != nil:
    section.add "api-version", valid_564132
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564133: Call_AccountsList_564127; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List and describe all NetApp accounts in the resource group
  ## 
  let valid = call_564133.validator(path, query, header, formData, body)
  let scheme = call_564133.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564133.url(scheme.get, call_564133.host, call_564133.base,
                         call_564133.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564133, url, valid)

proc call*(call_564134: Call_AccountsList_564127; subscriptionId: string;
          resourceGroupName: string; apiVersion: string = "2019-07-01"): Recallable =
  ## accountsList
  ## List and describe all NetApp accounts in the resource group
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  var path_564135 = newJObject()
  var query_564136 = newJObject()
  add(query_564136, "api-version", newJString(apiVersion))
  add(path_564135, "subscriptionId", newJString(subscriptionId))
  add(path_564135, "resourceGroupName", newJString(resourceGroupName))
  result = call_564134.call(path_564135, query_564136, nil, nil, nil)

var accountsList* = Call_AccountsList_564127(name: "accountsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.NetApp/netAppAccounts",
    validator: validate_AccountsList_564128, base: "", url: url_AccountsList_564129,
    schemes: {Scheme.Https})
type
  Call_AccountsCreateOrUpdate_564148 = ref object of OpenApiRestCall_563556
proc url_AccountsCreateOrUpdate_564150(protocol: Scheme; host: string; base: string;
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
        value: "/providers/Microsoft.NetApp/netAppAccounts/"),
               (kind: VariableSegment, value: "accountName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AccountsCreateOrUpdate_564149(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create or update the specified NetApp account within the resource group
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   accountName: JString (required)
  ##              : The name of the NetApp account
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564151 = path.getOrDefault("subscriptionId")
  valid_564151 = validateParameter(valid_564151, JString, required = true,
                                 default = nil)
  if valid_564151 != nil:
    section.add "subscriptionId", valid_564151
  var valid_564152 = path.getOrDefault("resourceGroupName")
  valid_564152 = validateParameter(valid_564152, JString, required = true,
                                 default = nil)
  if valid_564152 != nil:
    section.add "resourceGroupName", valid_564152
  var valid_564153 = path.getOrDefault("accountName")
  valid_564153 = validateParameter(valid_564153, JString, required = true,
                                 default = nil)
  if valid_564153 != nil:
    section.add "accountName", valid_564153
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564154 = query.getOrDefault("api-version")
  valid_564154 = validateParameter(valid_564154, JString, required = true,
                                 default = newJString("2019-07-01"))
  if valid_564154 != nil:
    section.add "api-version", valid_564154
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject (required)
  ##       : NetApp Account object supplied in the body of the operation.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564156: Call_AccountsCreateOrUpdate_564148; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create or update the specified NetApp account within the resource group
  ## 
  let valid = call_564156.validator(path, query, header, formData, body)
  let scheme = call_564156.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564156.url(scheme.get, call_564156.host, call_564156.base,
                         call_564156.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564156, url, valid)

proc call*(call_564157: Call_AccountsCreateOrUpdate_564148; subscriptionId: string;
          resourceGroupName: string; body: JsonNode; accountName: string;
          apiVersion: string = "2019-07-01"): Recallable =
  ## accountsCreateOrUpdate
  ## Create or update the specified NetApp account within the resource group
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   body: JObject (required)
  ##       : NetApp Account object supplied in the body of the operation.
  ##   accountName: string (required)
  ##              : The name of the NetApp account
  var path_564158 = newJObject()
  var query_564159 = newJObject()
  var body_564160 = newJObject()
  add(query_564159, "api-version", newJString(apiVersion))
  add(path_564158, "subscriptionId", newJString(subscriptionId))
  add(path_564158, "resourceGroupName", newJString(resourceGroupName))
  if body != nil:
    body_564160 = body
  add(path_564158, "accountName", newJString(accountName))
  result = call_564157.call(path_564158, query_564159, nil, nil, body_564160)

var accountsCreateOrUpdate* = Call_AccountsCreateOrUpdate_564148(
    name: "accountsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.NetApp/netAppAccounts/{accountName}",
    validator: validate_AccountsCreateOrUpdate_564149, base: "",
    url: url_AccountsCreateOrUpdate_564150, schemes: {Scheme.Https})
type
  Call_AccountsGet_564137 = ref object of OpenApiRestCall_563556
proc url_AccountsGet_564139(protocol: Scheme; host: string; base: string;
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
        value: "/providers/Microsoft.NetApp/netAppAccounts/"),
               (kind: VariableSegment, value: "accountName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AccountsGet_564138(path: JsonNode; query: JsonNode; header: JsonNode;
                                formData: JsonNode; body: JsonNode): JsonNode =
  ## Get the NetApp account
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   accountName: JString (required)
  ##              : The name of the NetApp account
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
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564143 = query.getOrDefault("api-version")
  valid_564143 = validateParameter(valid_564143, JString, required = true,
                                 default = newJString("2019-07-01"))
  if valid_564143 != nil:
    section.add "api-version", valid_564143
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564144: Call_AccountsGet_564137; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get the NetApp account
  ## 
  let valid = call_564144.validator(path, query, header, formData, body)
  let scheme = call_564144.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564144.url(scheme.get, call_564144.host, call_564144.base,
                         call_564144.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564144, url, valid)

proc call*(call_564145: Call_AccountsGet_564137; subscriptionId: string;
          resourceGroupName: string; accountName: string;
          apiVersion: string = "2019-07-01"): Recallable =
  ## accountsGet
  ## Get the NetApp account
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   accountName: string (required)
  ##              : The name of the NetApp account
  var path_564146 = newJObject()
  var query_564147 = newJObject()
  add(query_564147, "api-version", newJString(apiVersion))
  add(path_564146, "subscriptionId", newJString(subscriptionId))
  add(path_564146, "resourceGroupName", newJString(resourceGroupName))
  add(path_564146, "accountName", newJString(accountName))
  result = call_564145.call(path_564146, query_564147, nil, nil, nil)

var accountsGet* = Call_AccountsGet_564137(name: "accountsGet",
                                        meth: HttpMethod.HttpGet,
                                        host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.NetApp/netAppAccounts/{accountName}",
                                        validator: validate_AccountsGet_564138,
                                        base: "", url: url_AccountsGet_564139,
                                        schemes: {Scheme.Https})
type
  Call_AccountsUpdate_564172 = ref object of OpenApiRestCall_563556
proc url_AccountsUpdate_564174(protocol: Scheme; host: string; base: string;
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
        value: "/providers/Microsoft.NetApp/netAppAccounts/"),
               (kind: VariableSegment, value: "accountName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AccountsUpdate_564173(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Patch the specified NetApp account
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   accountName: JString (required)
  ##              : The name of the NetApp account
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564175 = path.getOrDefault("subscriptionId")
  valid_564175 = validateParameter(valid_564175, JString, required = true,
                                 default = nil)
  if valid_564175 != nil:
    section.add "subscriptionId", valid_564175
  var valid_564176 = path.getOrDefault("resourceGroupName")
  valid_564176 = validateParameter(valid_564176, JString, required = true,
                                 default = nil)
  if valid_564176 != nil:
    section.add "resourceGroupName", valid_564176
  var valid_564177 = path.getOrDefault("accountName")
  valid_564177 = validateParameter(valid_564177, JString, required = true,
                                 default = nil)
  if valid_564177 != nil:
    section.add "accountName", valid_564177
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564178 = query.getOrDefault("api-version")
  valid_564178 = validateParameter(valid_564178, JString, required = true,
                                 default = newJString("2019-07-01"))
  if valid_564178 != nil:
    section.add "api-version", valid_564178
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject (required)
  ##       : NetApp Account object supplied in the body of the operation.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564180: Call_AccountsUpdate_564172; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Patch the specified NetApp account
  ## 
  let valid = call_564180.validator(path, query, header, formData, body)
  let scheme = call_564180.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564180.url(scheme.get, call_564180.host, call_564180.base,
                         call_564180.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564180, url, valid)

proc call*(call_564181: Call_AccountsUpdate_564172; subscriptionId: string;
          resourceGroupName: string; body: JsonNode; accountName: string;
          apiVersion: string = "2019-07-01"): Recallable =
  ## accountsUpdate
  ## Patch the specified NetApp account
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   body: JObject (required)
  ##       : NetApp Account object supplied in the body of the operation.
  ##   accountName: string (required)
  ##              : The name of the NetApp account
  var path_564182 = newJObject()
  var query_564183 = newJObject()
  var body_564184 = newJObject()
  add(query_564183, "api-version", newJString(apiVersion))
  add(path_564182, "subscriptionId", newJString(subscriptionId))
  add(path_564182, "resourceGroupName", newJString(resourceGroupName))
  if body != nil:
    body_564184 = body
  add(path_564182, "accountName", newJString(accountName))
  result = call_564181.call(path_564182, query_564183, nil, nil, body_564184)

var accountsUpdate* = Call_AccountsUpdate_564172(name: "accountsUpdate",
    meth: HttpMethod.HttpPatch, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.NetApp/netAppAccounts/{accountName}",
    validator: validate_AccountsUpdate_564173, base: "", url: url_AccountsUpdate_564174,
    schemes: {Scheme.Https})
type
  Call_AccountsDelete_564161 = ref object of OpenApiRestCall_563556
proc url_AccountsDelete_564163(protocol: Scheme; host: string; base: string;
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
        value: "/providers/Microsoft.NetApp/netAppAccounts/"),
               (kind: VariableSegment, value: "accountName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AccountsDelete_564162(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Delete the specified NetApp account
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   accountName: JString (required)
  ##              : The name of the NetApp account
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
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
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564167 = query.getOrDefault("api-version")
  valid_564167 = validateParameter(valid_564167, JString, required = true,
                                 default = newJString("2019-07-01"))
  if valid_564167 != nil:
    section.add "api-version", valid_564167
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564168: Call_AccountsDelete_564161; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete the specified NetApp account
  ## 
  let valid = call_564168.validator(path, query, header, formData, body)
  let scheme = call_564168.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564168.url(scheme.get, call_564168.host, call_564168.base,
                         call_564168.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564168, url, valid)

proc call*(call_564169: Call_AccountsDelete_564161; subscriptionId: string;
          resourceGroupName: string; accountName: string;
          apiVersion: string = "2019-07-01"): Recallable =
  ## accountsDelete
  ## Delete the specified NetApp account
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   accountName: string (required)
  ##              : The name of the NetApp account
  var path_564170 = newJObject()
  var query_564171 = newJObject()
  add(query_564171, "api-version", newJString(apiVersion))
  add(path_564170, "subscriptionId", newJString(subscriptionId))
  add(path_564170, "resourceGroupName", newJString(resourceGroupName))
  add(path_564170, "accountName", newJString(accountName))
  result = call_564169.call(path_564170, query_564171, nil, nil, nil)

var accountsDelete* = Call_AccountsDelete_564161(name: "accountsDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.NetApp/netAppAccounts/{accountName}",
    validator: validate_AccountsDelete_564162, base: "", url: url_AccountsDelete_564163,
    schemes: {Scheme.Https})
type
  Call_PoolsList_564185 = ref object of OpenApiRestCall_563556
proc url_PoolsList_564187(protocol: Scheme; host: string; base: string; route: string;
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
        value: "/providers/Microsoft.NetApp/netAppAccounts/"),
               (kind: VariableSegment, value: "accountName"),
               (kind: ConstantSegment, value: "/capacityPools")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PoolsList_564186(path: JsonNode; query: JsonNode; header: JsonNode;
                              formData: JsonNode; body: JsonNode): JsonNode =
  ## List all capacity pools in the NetApp Account
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   accountName: JString (required)
  ##              : The name of the NetApp account
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564188 = path.getOrDefault("subscriptionId")
  valid_564188 = validateParameter(valid_564188, JString, required = true,
                                 default = nil)
  if valid_564188 != nil:
    section.add "subscriptionId", valid_564188
  var valid_564189 = path.getOrDefault("resourceGroupName")
  valid_564189 = validateParameter(valid_564189, JString, required = true,
                                 default = nil)
  if valid_564189 != nil:
    section.add "resourceGroupName", valid_564189
  var valid_564190 = path.getOrDefault("accountName")
  valid_564190 = validateParameter(valid_564190, JString, required = true,
                                 default = nil)
  if valid_564190 != nil:
    section.add "accountName", valid_564190
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564191 = query.getOrDefault("api-version")
  valid_564191 = validateParameter(valid_564191, JString, required = true,
                                 default = newJString("2019-07-01"))
  if valid_564191 != nil:
    section.add "api-version", valid_564191
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564192: Call_PoolsList_564185; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List all capacity pools in the NetApp Account
  ## 
  let valid = call_564192.validator(path, query, header, formData, body)
  let scheme = call_564192.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564192.url(scheme.get, call_564192.host, call_564192.base,
                         call_564192.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564192, url, valid)

proc call*(call_564193: Call_PoolsList_564185; subscriptionId: string;
          resourceGroupName: string; accountName: string;
          apiVersion: string = "2019-07-01"): Recallable =
  ## poolsList
  ## List all capacity pools in the NetApp Account
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   accountName: string (required)
  ##              : The name of the NetApp account
  var path_564194 = newJObject()
  var query_564195 = newJObject()
  add(query_564195, "api-version", newJString(apiVersion))
  add(path_564194, "subscriptionId", newJString(subscriptionId))
  add(path_564194, "resourceGroupName", newJString(resourceGroupName))
  add(path_564194, "accountName", newJString(accountName))
  result = call_564193.call(path_564194, query_564195, nil, nil, nil)

var poolsList* = Call_PoolsList_564185(name: "poolsList", meth: HttpMethod.HttpGet,
                                    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.NetApp/netAppAccounts/{accountName}/capacityPools",
                                    validator: validate_PoolsList_564186,
                                    base: "", url: url_PoolsList_564187,
                                    schemes: {Scheme.Https})
type
  Call_PoolsCreateOrUpdate_564208 = ref object of OpenApiRestCall_563556
proc url_PoolsCreateOrUpdate_564210(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "accountName" in path, "`accountName` is a required path parameter"
  assert "poolName" in path, "`poolName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.NetApp/netAppAccounts/"),
               (kind: VariableSegment, value: "accountName"),
               (kind: ConstantSegment, value: "/capacityPools/"),
               (kind: VariableSegment, value: "poolName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PoolsCreateOrUpdate_564209(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Create or Update a capacity pool
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   poolName: JString (required)
  ##           : The name of the capacity pool
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   accountName: JString (required)
  ##              : The name of the NetApp account
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564211 = path.getOrDefault("subscriptionId")
  valid_564211 = validateParameter(valid_564211, JString, required = true,
                                 default = nil)
  if valid_564211 != nil:
    section.add "subscriptionId", valid_564211
  var valid_564212 = path.getOrDefault("poolName")
  valid_564212 = validateParameter(valid_564212, JString, required = true,
                                 default = nil)
  if valid_564212 != nil:
    section.add "poolName", valid_564212
  var valid_564213 = path.getOrDefault("resourceGroupName")
  valid_564213 = validateParameter(valid_564213, JString, required = true,
                                 default = nil)
  if valid_564213 != nil:
    section.add "resourceGroupName", valid_564213
  var valid_564214 = path.getOrDefault("accountName")
  valid_564214 = validateParameter(valid_564214, JString, required = true,
                                 default = nil)
  if valid_564214 != nil:
    section.add "accountName", valid_564214
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564215 = query.getOrDefault("api-version")
  valid_564215 = validateParameter(valid_564215, JString, required = true,
                                 default = newJString("2019-07-01"))
  if valid_564215 != nil:
    section.add "api-version", valid_564215
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject (required)
  ##       : Capacity pool object supplied in the body of the operation.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564217: Call_PoolsCreateOrUpdate_564208; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create or Update a capacity pool
  ## 
  let valid = call_564217.validator(path, query, header, formData, body)
  let scheme = call_564217.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564217.url(scheme.get, call_564217.host, call_564217.base,
                         call_564217.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564217, url, valid)

proc call*(call_564218: Call_PoolsCreateOrUpdate_564208; subscriptionId: string;
          poolName: string; resourceGroupName: string; body: JsonNode;
          accountName: string; apiVersion: string = "2019-07-01"): Recallable =
  ## poolsCreateOrUpdate
  ## Create or Update a capacity pool
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   poolName: string (required)
  ##           : The name of the capacity pool
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   body: JObject (required)
  ##       : Capacity pool object supplied in the body of the operation.
  ##   accountName: string (required)
  ##              : The name of the NetApp account
  var path_564219 = newJObject()
  var query_564220 = newJObject()
  var body_564221 = newJObject()
  add(query_564220, "api-version", newJString(apiVersion))
  add(path_564219, "subscriptionId", newJString(subscriptionId))
  add(path_564219, "poolName", newJString(poolName))
  add(path_564219, "resourceGroupName", newJString(resourceGroupName))
  if body != nil:
    body_564221 = body
  add(path_564219, "accountName", newJString(accountName))
  result = call_564218.call(path_564219, query_564220, nil, nil, body_564221)

var poolsCreateOrUpdate* = Call_PoolsCreateOrUpdate_564208(
    name: "poolsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.NetApp/netAppAccounts/{accountName}/capacityPools/{poolName}",
    validator: validate_PoolsCreateOrUpdate_564209, base: "",
    url: url_PoolsCreateOrUpdate_564210, schemes: {Scheme.Https})
type
  Call_PoolsGet_564196 = ref object of OpenApiRestCall_563556
proc url_PoolsGet_564198(protocol: Scheme; host: string; base: string; route: string;
                        path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "accountName" in path, "`accountName` is a required path parameter"
  assert "poolName" in path, "`poolName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.NetApp/netAppAccounts/"),
               (kind: VariableSegment, value: "accountName"),
               (kind: ConstantSegment, value: "/capacityPools/"),
               (kind: VariableSegment, value: "poolName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PoolsGet_564197(path: JsonNode; query: JsonNode; header: JsonNode;
                             formData: JsonNode; body: JsonNode): JsonNode =
  ## Get details of the specified capacity pool
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   poolName: JString (required)
  ##           : The name of the capacity pool
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   accountName: JString (required)
  ##              : The name of the NetApp account
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564199 = path.getOrDefault("subscriptionId")
  valid_564199 = validateParameter(valid_564199, JString, required = true,
                                 default = nil)
  if valid_564199 != nil:
    section.add "subscriptionId", valid_564199
  var valid_564200 = path.getOrDefault("poolName")
  valid_564200 = validateParameter(valid_564200, JString, required = true,
                                 default = nil)
  if valid_564200 != nil:
    section.add "poolName", valid_564200
  var valid_564201 = path.getOrDefault("resourceGroupName")
  valid_564201 = validateParameter(valid_564201, JString, required = true,
                                 default = nil)
  if valid_564201 != nil:
    section.add "resourceGroupName", valid_564201
  var valid_564202 = path.getOrDefault("accountName")
  valid_564202 = validateParameter(valid_564202, JString, required = true,
                                 default = nil)
  if valid_564202 != nil:
    section.add "accountName", valid_564202
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564203 = query.getOrDefault("api-version")
  valid_564203 = validateParameter(valid_564203, JString, required = true,
                                 default = newJString("2019-07-01"))
  if valid_564203 != nil:
    section.add "api-version", valid_564203
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564204: Call_PoolsGet_564196; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get details of the specified capacity pool
  ## 
  let valid = call_564204.validator(path, query, header, formData, body)
  let scheme = call_564204.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564204.url(scheme.get, call_564204.host, call_564204.base,
                         call_564204.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564204, url, valid)

proc call*(call_564205: Call_PoolsGet_564196; subscriptionId: string;
          poolName: string; resourceGroupName: string; accountName: string;
          apiVersion: string = "2019-07-01"): Recallable =
  ## poolsGet
  ## Get details of the specified capacity pool
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   poolName: string (required)
  ##           : The name of the capacity pool
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   accountName: string (required)
  ##              : The name of the NetApp account
  var path_564206 = newJObject()
  var query_564207 = newJObject()
  add(query_564207, "api-version", newJString(apiVersion))
  add(path_564206, "subscriptionId", newJString(subscriptionId))
  add(path_564206, "poolName", newJString(poolName))
  add(path_564206, "resourceGroupName", newJString(resourceGroupName))
  add(path_564206, "accountName", newJString(accountName))
  result = call_564205.call(path_564206, query_564207, nil, nil, nil)

var poolsGet* = Call_PoolsGet_564196(name: "poolsGet", meth: HttpMethod.HttpGet,
                                  host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.NetApp/netAppAccounts/{accountName}/capacityPools/{poolName}",
                                  validator: validate_PoolsGet_564197, base: "",
                                  url: url_PoolsGet_564198,
                                  schemes: {Scheme.Https})
type
  Call_PoolsUpdate_564234 = ref object of OpenApiRestCall_563556
proc url_PoolsUpdate_564236(protocol: Scheme; host: string; base: string;
                           route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "accountName" in path, "`accountName` is a required path parameter"
  assert "poolName" in path, "`poolName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.NetApp/netAppAccounts/"),
               (kind: VariableSegment, value: "accountName"),
               (kind: ConstantSegment, value: "/capacityPools/"),
               (kind: VariableSegment, value: "poolName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PoolsUpdate_564235(path: JsonNode; query: JsonNode; header: JsonNode;
                                formData: JsonNode; body: JsonNode): JsonNode =
  ## Patch the specified capacity pool
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   poolName: JString (required)
  ##           : The name of the capacity pool
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   accountName: JString (required)
  ##              : The name of the NetApp account
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564237 = path.getOrDefault("subscriptionId")
  valid_564237 = validateParameter(valid_564237, JString, required = true,
                                 default = nil)
  if valid_564237 != nil:
    section.add "subscriptionId", valid_564237
  var valid_564238 = path.getOrDefault("poolName")
  valid_564238 = validateParameter(valid_564238, JString, required = true,
                                 default = nil)
  if valid_564238 != nil:
    section.add "poolName", valid_564238
  var valid_564239 = path.getOrDefault("resourceGroupName")
  valid_564239 = validateParameter(valid_564239, JString, required = true,
                                 default = nil)
  if valid_564239 != nil:
    section.add "resourceGroupName", valid_564239
  var valid_564240 = path.getOrDefault("accountName")
  valid_564240 = validateParameter(valid_564240, JString, required = true,
                                 default = nil)
  if valid_564240 != nil:
    section.add "accountName", valid_564240
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564241 = query.getOrDefault("api-version")
  valid_564241 = validateParameter(valid_564241, JString, required = true,
                                 default = newJString("2019-07-01"))
  if valid_564241 != nil:
    section.add "api-version", valid_564241
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject (required)
  ##       : Capacity pool object supplied in the body of the operation.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564243: Call_PoolsUpdate_564234; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Patch the specified capacity pool
  ## 
  let valid = call_564243.validator(path, query, header, formData, body)
  let scheme = call_564243.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564243.url(scheme.get, call_564243.host, call_564243.base,
                         call_564243.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564243, url, valid)

proc call*(call_564244: Call_PoolsUpdate_564234; subscriptionId: string;
          poolName: string; resourceGroupName: string; body: JsonNode;
          accountName: string; apiVersion: string = "2019-07-01"): Recallable =
  ## poolsUpdate
  ## Patch the specified capacity pool
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   poolName: string (required)
  ##           : The name of the capacity pool
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   body: JObject (required)
  ##       : Capacity pool object supplied in the body of the operation.
  ##   accountName: string (required)
  ##              : The name of the NetApp account
  var path_564245 = newJObject()
  var query_564246 = newJObject()
  var body_564247 = newJObject()
  add(query_564246, "api-version", newJString(apiVersion))
  add(path_564245, "subscriptionId", newJString(subscriptionId))
  add(path_564245, "poolName", newJString(poolName))
  add(path_564245, "resourceGroupName", newJString(resourceGroupName))
  if body != nil:
    body_564247 = body
  add(path_564245, "accountName", newJString(accountName))
  result = call_564244.call(path_564245, query_564246, nil, nil, body_564247)

var poolsUpdate* = Call_PoolsUpdate_564234(name: "poolsUpdate",
                                        meth: HttpMethod.HttpPatch,
                                        host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.NetApp/netAppAccounts/{accountName}/capacityPools/{poolName}",
                                        validator: validate_PoolsUpdate_564235,
                                        base: "", url: url_PoolsUpdate_564236,
                                        schemes: {Scheme.Https})
type
  Call_PoolsDelete_564222 = ref object of OpenApiRestCall_563556
proc url_PoolsDelete_564224(protocol: Scheme; host: string; base: string;
                           route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "accountName" in path, "`accountName` is a required path parameter"
  assert "poolName" in path, "`poolName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.NetApp/netAppAccounts/"),
               (kind: VariableSegment, value: "accountName"),
               (kind: ConstantSegment, value: "/capacityPools/"),
               (kind: VariableSegment, value: "poolName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PoolsDelete_564223(path: JsonNode; query: JsonNode; header: JsonNode;
                                formData: JsonNode; body: JsonNode): JsonNode =
  ## Delete the specified capacity pool
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   poolName: JString (required)
  ##           : The name of the capacity pool
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   accountName: JString (required)
  ##              : The name of the NetApp account
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564225 = path.getOrDefault("subscriptionId")
  valid_564225 = validateParameter(valid_564225, JString, required = true,
                                 default = nil)
  if valid_564225 != nil:
    section.add "subscriptionId", valid_564225
  var valid_564226 = path.getOrDefault("poolName")
  valid_564226 = validateParameter(valid_564226, JString, required = true,
                                 default = nil)
  if valid_564226 != nil:
    section.add "poolName", valid_564226
  var valid_564227 = path.getOrDefault("resourceGroupName")
  valid_564227 = validateParameter(valid_564227, JString, required = true,
                                 default = nil)
  if valid_564227 != nil:
    section.add "resourceGroupName", valid_564227
  var valid_564228 = path.getOrDefault("accountName")
  valid_564228 = validateParameter(valid_564228, JString, required = true,
                                 default = nil)
  if valid_564228 != nil:
    section.add "accountName", valid_564228
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564229 = query.getOrDefault("api-version")
  valid_564229 = validateParameter(valid_564229, JString, required = true,
                                 default = newJString("2019-07-01"))
  if valid_564229 != nil:
    section.add "api-version", valid_564229
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564230: Call_PoolsDelete_564222; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete the specified capacity pool
  ## 
  let valid = call_564230.validator(path, query, header, formData, body)
  let scheme = call_564230.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564230.url(scheme.get, call_564230.host, call_564230.base,
                         call_564230.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564230, url, valid)

proc call*(call_564231: Call_PoolsDelete_564222; subscriptionId: string;
          poolName: string; resourceGroupName: string; accountName: string;
          apiVersion: string = "2019-07-01"): Recallable =
  ## poolsDelete
  ## Delete the specified capacity pool
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   poolName: string (required)
  ##           : The name of the capacity pool
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   accountName: string (required)
  ##              : The name of the NetApp account
  var path_564232 = newJObject()
  var query_564233 = newJObject()
  add(query_564233, "api-version", newJString(apiVersion))
  add(path_564232, "subscriptionId", newJString(subscriptionId))
  add(path_564232, "poolName", newJString(poolName))
  add(path_564232, "resourceGroupName", newJString(resourceGroupName))
  add(path_564232, "accountName", newJString(accountName))
  result = call_564231.call(path_564232, query_564233, nil, nil, nil)

var poolsDelete* = Call_PoolsDelete_564222(name: "poolsDelete",
                                        meth: HttpMethod.HttpDelete,
                                        host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.NetApp/netAppAccounts/{accountName}/capacityPools/{poolName}",
                                        validator: validate_PoolsDelete_564223,
                                        base: "", url: url_PoolsDelete_564224,
                                        schemes: {Scheme.Https})
type
  Call_VolumesList_564248 = ref object of OpenApiRestCall_563556
proc url_VolumesList_564250(protocol: Scheme; host: string; base: string;
                           route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "accountName" in path, "`accountName` is a required path parameter"
  assert "poolName" in path, "`poolName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.NetApp/netAppAccounts/"),
               (kind: VariableSegment, value: "accountName"),
               (kind: ConstantSegment, value: "/capacityPools/"),
               (kind: VariableSegment, value: "poolName"),
               (kind: ConstantSegment, value: "/volumes")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VolumesList_564249(path: JsonNode; query: JsonNode; header: JsonNode;
                                formData: JsonNode; body: JsonNode): JsonNode =
  ## List all volumes within the capacity pool
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   poolName: JString (required)
  ##           : The name of the capacity pool
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   accountName: JString (required)
  ##              : The name of the NetApp account
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564251 = path.getOrDefault("subscriptionId")
  valid_564251 = validateParameter(valid_564251, JString, required = true,
                                 default = nil)
  if valid_564251 != nil:
    section.add "subscriptionId", valid_564251
  var valid_564252 = path.getOrDefault("poolName")
  valid_564252 = validateParameter(valid_564252, JString, required = true,
                                 default = nil)
  if valid_564252 != nil:
    section.add "poolName", valid_564252
  var valid_564253 = path.getOrDefault("resourceGroupName")
  valid_564253 = validateParameter(valid_564253, JString, required = true,
                                 default = nil)
  if valid_564253 != nil:
    section.add "resourceGroupName", valid_564253
  var valid_564254 = path.getOrDefault("accountName")
  valid_564254 = validateParameter(valid_564254, JString, required = true,
                                 default = nil)
  if valid_564254 != nil:
    section.add "accountName", valid_564254
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564255 = query.getOrDefault("api-version")
  valid_564255 = validateParameter(valid_564255, JString, required = true,
                                 default = newJString("2019-07-01"))
  if valid_564255 != nil:
    section.add "api-version", valid_564255
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564256: Call_VolumesList_564248; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List all volumes within the capacity pool
  ## 
  let valid = call_564256.validator(path, query, header, formData, body)
  let scheme = call_564256.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564256.url(scheme.get, call_564256.host, call_564256.base,
                         call_564256.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564256, url, valid)

proc call*(call_564257: Call_VolumesList_564248; subscriptionId: string;
          poolName: string; resourceGroupName: string; accountName: string;
          apiVersion: string = "2019-07-01"): Recallable =
  ## volumesList
  ## List all volumes within the capacity pool
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   poolName: string (required)
  ##           : The name of the capacity pool
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   accountName: string (required)
  ##              : The name of the NetApp account
  var path_564258 = newJObject()
  var query_564259 = newJObject()
  add(query_564259, "api-version", newJString(apiVersion))
  add(path_564258, "subscriptionId", newJString(subscriptionId))
  add(path_564258, "poolName", newJString(poolName))
  add(path_564258, "resourceGroupName", newJString(resourceGroupName))
  add(path_564258, "accountName", newJString(accountName))
  result = call_564257.call(path_564258, query_564259, nil, nil, nil)

var volumesList* = Call_VolumesList_564248(name: "volumesList",
                                        meth: HttpMethod.HttpGet,
                                        host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.NetApp/netAppAccounts/{accountName}/capacityPools/{poolName}/volumes",
                                        validator: validate_VolumesList_564249,
                                        base: "", url: url_VolumesList_564250,
                                        schemes: {Scheme.Https})
type
  Call_VolumesCreateOrUpdate_564273 = ref object of OpenApiRestCall_563556
proc url_VolumesCreateOrUpdate_564275(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "accountName" in path, "`accountName` is a required path parameter"
  assert "poolName" in path, "`poolName` is a required path parameter"
  assert "volumeName" in path, "`volumeName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.NetApp/netAppAccounts/"),
               (kind: VariableSegment, value: "accountName"),
               (kind: ConstantSegment, value: "/capacityPools/"),
               (kind: VariableSegment, value: "poolName"),
               (kind: ConstantSegment, value: "/volumes/"),
               (kind: VariableSegment, value: "volumeName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VolumesCreateOrUpdate_564274(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create or update the specified volume within the capacity pool
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   volumeName: JString (required)
  ##             : The name of the volume
  ##   poolName: JString (required)
  ##           : The name of the capacity pool
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   accountName: JString (required)
  ##              : The name of the NetApp account
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564276 = path.getOrDefault("subscriptionId")
  valid_564276 = validateParameter(valid_564276, JString, required = true,
                                 default = nil)
  if valid_564276 != nil:
    section.add "subscriptionId", valid_564276
  var valid_564277 = path.getOrDefault("volumeName")
  valid_564277 = validateParameter(valid_564277, JString, required = true,
                                 default = nil)
  if valid_564277 != nil:
    section.add "volumeName", valid_564277
  var valid_564278 = path.getOrDefault("poolName")
  valid_564278 = validateParameter(valid_564278, JString, required = true,
                                 default = nil)
  if valid_564278 != nil:
    section.add "poolName", valid_564278
  var valid_564279 = path.getOrDefault("resourceGroupName")
  valid_564279 = validateParameter(valid_564279, JString, required = true,
                                 default = nil)
  if valid_564279 != nil:
    section.add "resourceGroupName", valid_564279
  var valid_564280 = path.getOrDefault("accountName")
  valid_564280 = validateParameter(valid_564280, JString, required = true,
                                 default = nil)
  if valid_564280 != nil:
    section.add "accountName", valid_564280
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564281 = query.getOrDefault("api-version")
  valid_564281 = validateParameter(valid_564281, JString, required = true,
                                 default = newJString("2019-07-01"))
  if valid_564281 != nil:
    section.add "api-version", valid_564281
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject (required)
  ##       : Volume object supplied in the body of the operation.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564283: Call_VolumesCreateOrUpdate_564273; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create or update the specified volume within the capacity pool
  ## 
  let valid = call_564283.validator(path, query, header, formData, body)
  let scheme = call_564283.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564283.url(scheme.get, call_564283.host, call_564283.base,
                         call_564283.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564283, url, valid)

proc call*(call_564284: Call_VolumesCreateOrUpdate_564273; subscriptionId: string;
          volumeName: string; poolName: string; resourceGroupName: string;
          body: JsonNode; accountName: string; apiVersion: string = "2019-07-01"): Recallable =
  ## volumesCreateOrUpdate
  ## Create or update the specified volume within the capacity pool
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   volumeName: string (required)
  ##             : The name of the volume
  ##   poolName: string (required)
  ##           : The name of the capacity pool
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   body: JObject (required)
  ##       : Volume object supplied in the body of the operation.
  ##   accountName: string (required)
  ##              : The name of the NetApp account
  var path_564285 = newJObject()
  var query_564286 = newJObject()
  var body_564287 = newJObject()
  add(query_564286, "api-version", newJString(apiVersion))
  add(path_564285, "subscriptionId", newJString(subscriptionId))
  add(path_564285, "volumeName", newJString(volumeName))
  add(path_564285, "poolName", newJString(poolName))
  add(path_564285, "resourceGroupName", newJString(resourceGroupName))
  if body != nil:
    body_564287 = body
  add(path_564285, "accountName", newJString(accountName))
  result = call_564284.call(path_564285, query_564286, nil, nil, body_564287)

var volumesCreateOrUpdate* = Call_VolumesCreateOrUpdate_564273(
    name: "volumesCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.NetApp/netAppAccounts/{accountName}/capacityPools/{poolName}/volumes/{volumeName}",
    validator: validate_VolumesCreateOrUpdate_564274, base: "",
    url: url_VolumesCreateOrUpdate_564275, schemes: {Scheme.Https})
type
  Call_VolumesGet_564260 = ref object of OpenApiRestCall_563556
proc url_VolumesGet_564262(protocol: Scheme; host: string; base: string; route: string;
                          path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "accountName" in path, "`accountName` is a required path parameter"
  assert "poolName" in path, "`poolName` is a required path parameter"
  assert "volumeName" in path, "`volumeName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.NetApp/netAppAccounts/"),
               (kind: VariableSegment, value: "accountName"),
               (kind: ConstantSegment, value: "/capacityPools/"),
               (kind: VariableSegment, value: "poolName"),
               (kind: ConstantSegment, value: "/volumes/"),
               (kind: VariableSegment, value: "volumeName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VolumesGet_564261(path: JsonNode; query: JsonNode; header: JsonNode;
                               formData: JsonNode; body: JsonNode): JsonNode =
  ## Get the details of the specified volume
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   volumeName: JString (required)
  ##             : The name of the volume
  ##   poolName: JString (required)
  ##           : The name of the capacity pool
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   accountName: JString (required)
  ##              : The name of the NetApp account
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564263 = path.getOrDefault("subscriptionId")
  valid_564263 = validateParameter(valid_564263, JString, required = true,
                                 default = nil)
  if valid_564263 != nil:
    section.add "subscriptionId", valid_564263
  var valid_564264 = path.getOrDefault("volumeName")
  valid_564264 = validateParameter(valid_564264, JString, required = true,
                                 default = nil)
  if valid_564264 != nil:
    section.add "volumeName", valid_564264
  var valid_564265 = path.getOrDefault("poolName")
  valid_564265 = validateParameter(valid_564265, JString, required = true,
                                 default = nil)
  if valid_564265 != nil:
    section.add "poolName", valid_564265
  var valid_564266 = path.getOrDefault("resourceGroupName")
  valid_564266 = validateParameter(valid_564266, JString, required = true,
                                 default = nil)
  if valid_564266 != nil:
    section.add "resourceGroupName", valid_564266
  var valid_564267 = path.getOrDefault("accountName")
  valid_564267 = validateParameter(valid_564267, JString, required = true,
                                 default = nil)
  if valid_564267 != nil:
    section.add "accountName", valid_564267
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564268 = query.getOrDefault("api-version")
  valid_564268 = validateParameter(valid_564268, JString, required = true,
                                 default = newJString("2019-07-01"))
  if valid_564268 != nil:
    section.add "api-version", valid_564268
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564269: Call_VolumesGet_564260; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get the details of the specified volume
  ## 
  let valid = call_564269.validator(path, query, header, formData, body)
  let scheme = call_564269.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564269.url(scheme.get, call_564269.host, call_564269.base,
                         call_564269.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564269, url, valid)

proc call*(call_564270: Call_VolumesGet_564260; subscriptionId: string;
          volumeName: string; poolName: string; resourceGroupName: string;
          accountName: string; apiVersion: string = "2019-07-01"): Recallable =
  ## volumesGet
  ## Get the details of the specified volume
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   volumeName: string (required)
  ##             : The name of the volume
  ##   poolName: string (required)
  ##           : The name of the capacity pool
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   accountName: string (required)
  ##              : The name of the NetApp account
  var path_564271 = newJObject()
  var query_564272 = newJObject()
  add(query_564272, "api-version", newJString(apiVersion))
  add(path_564271, "subscriptionId", newJString(subscriptionId))
  add(path_564271, "volumeName", newJString(volumeName))
  add(path_564271, "poolName", newJString(poolName))
  add(path_564271, "resourceGroupName", newJString(resourceGroupName))
  add(path_564271, "accountName", newJString(accountName))
  result = call_564270.call(path_564271, query_564272, nil, nil, nil)

var volumesGet* = Call_VolumesGet_564260(name: "volumesGet",
                                      meth: HttpMethod.HttpGet,
                                      host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.NetApp/netAppAccounts/{accountName}/capacityPools/{poolName}/volumes/{volumeName}",
                                      validator: validate_VolumesGet_564261,
                                      base: "", url: url_VolumesGet_564262,
                                      schemes: {Scheme.Https})
type
  Call_VolumesUpdate_564301 = ref object of OpenApiRestCall_563556
proc url_VolumesUpdate_564303(protocol: Scheme; host: string; base: string;
                             route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "accountName" in path, "`accountName` is a required path parameter"
  assert "poolName" in path, "`poolName` is a required path parameter"
  assert "volumeName" in path, "`volumeName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.NetApp/netAppAccounts/"),
               (kind: VariableSegment, value: "accountName"),
               (kind: ConstantSegment, value: "/capacityPools/"),
               (kind: VariableSegment, value: "poolName"),
               (kind: ConstantSegment, value: "/volumes/"),
               (kind: VariableSegment, value: "volumeName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VolumesUpdate_564302(path: JsonNode; query: JsonNode; header: JsonNode;
                                  formData: JsonNode; body: JsonNode): JsonNode =
  ## Patch the specified volume
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   volumeName: JString (required)
  ##             : The name of the volume
  ##   poolName: JString (required)
  ##           : The name of the capacity pool
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   accountName: JString (required)
  ##              : The name of the NetApp account
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564304 = path.getOrDefault("subscriptionId")
  valid_564304 = validateParameter(valid_564304, JString, required = true,
                                 default = nil)
  if valid_564304 != nil:
    section.add "subscriptionId", valid_564304
  var valid_564305 = path.getOrDefault("volumeName")
  valid_564305 = validateParameter(valid_564305, JString, required = true,
                                 default = nil)
  if valid_564305 != nil:
    section.add "volumeName", valid_564305
  var valid_564306 = path.getOrDefault("poolName")
  valid_564306 = validateParameter(valid_564306, JString, required = true,
                                 default = nil)
  if valid_564306 != nil:
    section.add "poolName", valid_564306
  var valid_564307 = path.getOrDefault("resourceGroupName")
  valid_564307 = validateParameter(valid_564307, JString, required = true,
                                 default = nil)
  if valid_564307 != nil:
    section.add "resourceGroupName", valid_564307
  var valid_564308 = path.getOrDefault("accountName")
  valid_564308 = validateParameter(valid_564308, JString, required = true,
                                 default = nil)
  if valid_564308 != nil:
    section.add "accountName", valid_564308
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564309 = query.getOrDefault("api-version")
  valid_564309 = validateParameter(valid_564309, JString, required = true,
                                 default = newJString("2019-07-01"))
  if valid_564309 != nil:
    section.add "api-version", valid_564309
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject (required)
  ##       : Volume object supplied in the body of the operation.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564311: Call_VolumesUpdate_564301; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Patch the specified volume
  ## 
  let valid = call_564311.validator(path, query, header, formData, body)
  let scheme = call_564311.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564311.url(scheme.get, call_564311.host, call_564311.base,
                         call_564311.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564311, url, valid)

proc call*(call_564312: Call_VolumesUpdate_564301; subscriptionId: string;
          volumeName: string; poolName: string; resourceGroupName: string;
          body: JsonNode; accountName: string; apiVersion: string = "2019-07-01"): Recallable =
  ## volumesUpdate
  ## Patch the specified volume
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   volumeName: string (required)
  ##             : The name of the volume
  ##   poolName: string (required)
  ##           : The name of the capacity pool
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   body: JObject (required)
  ##       : Volume object supplied in the body of the operation.
  ##   accountName: string (required)
  ##              : The name of the NetApp account
  var path_564313 = newJObject()
  var query_564314 = newJObject()
  var body_564315 = newJObject()
  add(query_564314, "api-version", newJString(apiVersion))
  add(path_564313, "subscriptionId", newJString(subscriptionId))
  add(path_564313, "volumeName", newJString(volumeName))
  add(path_564313, "poolName", newJString(poolName))
  add(path_564313, "resourceGroupName", newJString(resourceGroupName))
  if body != nil:
    body_564315 = body
  add(path_564313, "accountName", newJString(accountName))
  result = call_564312.call(path_564313, query_564314, nil, nil, body_564315)

var volumesUpdate* = Call_VolumesUpdate_564301(name: "volumesUpdate",
    meth: HttpMethod.HttpPatch, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.NetApp/netAppAccounts/{accountName}/capacityPools/{poolName}/volumes/{volumeName}",
    validator: validate_VolumesUpdate_564302, base: "", url: url_VolumesUpdate_564303,
    schemes: {Scheme.Https})
type
  Call_VolumesDelete_564288 = ref object of OpenApiRestCall_563556
proc url_VolumesDelete_564290(protocol: Scheme; host: string; base: string;
                             route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "accountName" in path, "`accountName` is a required path parameter"
  assert "poolName" in path, "`poolName` is a required path parameter"
  assert "volumeName" in path, "`volumeName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.NetApp/netAppAccounts/"),
               (kind: VariableSegment, value: "accountName"),
               (kind: ConstantSegment, value: "/capacityPools/"),
               (kind: VariableSegment, value: "poolName"),
               (kind: ConstantSegment, value: "/volumes/"),
               (kind: VariableSegment, value: "volumeName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VolumesDelete_564289(path: JsonNode; query: JsonNode; header: JsonNode;
                                  formData: JsonNode; body: JsonNode): JsonNode =
  ## Delete the specified volume
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   volumeName: JString (required)
  ##             : The name of the volume
  ##   poolName: JString (required)
  ##           : The name of the capacity pool
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   accountName: JString (required)
  ##              : The name of the NetApp account
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564291 = path.getOrDefault("subscriptionId")
  valid_564291 = validateParameter(valid_564291, JString, required = true,
                                 default = nil)
  if valid_564291 != nil:
    section.add "subscriptionId", valid_564291
  var valid_564292 = path.getOrDefault("volumeName")
  valid_564292 = validateParameter(valid_564292, JString, required = true,
                                 default = nil)
  if valid_564292 != nil:
    section.add "volumeName", valid_564292
  var valid_564293 = path.getOrDefault("poolName")
  valid_564293 = validateParameter(valid_564293, JString, required = true,
                                 default = nil)
  if valid_564293 != nil:
    section.add "poolName", valid_564293
  var valid_564294 = path.getOrDefault("resourceGroupName")
  valid_564294 = validateParameter(valid_564294, JString, required = true,
                                 default = nil)
  if valid_564294 != nil:
    section.add "resourceGroupName", valid_564294
  var valid_564295 = path.getOrDefault("accountName")
  valid_564295 = validateParameter(valid_564295, JString, required = true,
                                 default = nil)
  if valid_564295 != nil:
    section.add "accountName", valid_564295
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564296 = query.getOrDefault("api-version")
  valid_564296 = validateParameter(valid_564296, JString, required = true,
                                 default = newJString("2019-07-01"))
  if valid_564296 != nil:
    section.add "api-version", valid_564296
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564297: Call_VolumesDelete_564288; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete the specified volume
  ## 
  let valid = call_564297.validator(path, query, header, formData, body)
  let scheme = call_564297.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564297.url(scheme.get, call_564297.host, call_564297.base,
                         call_564297.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564297, url, valid)

proc call*(call_564298: Call_VolumesDelete_564288; subscriptionId: string;
          volumeName: string; poolName: string; resourceGroupName: string;
          accountName: string; apiVersion: string = "2019-07-01"): Recallable =
  ## volumesDelete
  ## Delete the specified volume
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   volumeName: string (required)
  ##             : The name of the volume
  ##   poolName: string (required)
  ##           : The name of the capacity pool
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   accountName: string (required)
  ##              : The name of the NetApp account
  var path_564299 = newJObject()
  var query_564300 = newJObject()
  add(query_564300, "api-version", newJString(apiVersion))
  add(path_564299, "subscriptionId", newJString(subscriptionId))
  add(path_564299, "volumeName", newJString(volumeName))
  add(path_564299, "poolName", newJString(poolName))
  add(path_564299, "resourceGroupName", newJString(resourceGroupName))
  add(path_564299, "accountName", newJString(accountName))
  result = call_564298.call(path_564299, query_564300, nil, nil, nil)

var volumesDelete* = Call_VolumesDelete_564288(name: "volumesDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.NetApp/netAppAccounts/{accountName}/capacityPools/{poolName}/volumes/{volumeName}",
    validator: validate_VolumesDelete_564289, base: "", url: url_VolumesDelete_564290,
    schemes: {Scheme.Https})
type
  Call_MountTargetsList_564316 = ref object of OpenApiRestCall_563556
proc url_MountTargetsList_564318(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "accountName" in path, "`accountName` is a required path parameter"
  assert "poolName" in path, "`poolName` is a required path parameter"
  assert "volumeName" in path, "`volumeName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.NetApp/netAppAccounts/"),
               (kind: VariableSegment, value: "accountName"),
               (kind: ConstantSegment, value: "/capacityPools/"),
               (kind: VariableSegment, value: "poolName"),
               (kind: ConstantSegment, value: "/volumes/"),
               (kind: VariableSegment, value: "volumeName"),
               (kind: ConstantSegment, value: "/mountTargets")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_MountTargetsList_564317(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## List all mount targets associated with the volume
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   volumeName: JString (required)
  ##             : The name of the volume
  ##   poolName: JString (required)
  ##           : The name of the capacity pool
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   accountName: JString (required)
  ##              : The name of the NetApp account
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564319 = path.getOrDefault("subscriptionId")
  valid_564319 = validateParameter(valid_564319, JString, required = true,
                                 default = nil)
  if valid_564319 != nil:
    section.add "subscriptionId", valid_564319
  var valid_564320 = path.getOrDefault("volumeName")
  valid_564320 = validateParameter(valid_564320, JString, required = true,
                                 default = nil)
  if valid_564320 != nil:
    section.add "volumeName", valid_564320
  var valid_564321 = path.getOrDefault("poolName")
  valid_564321 = validateParameter(valid_564321, JString, required = true,
                                 default = nil)
  if valid_564321 != nil:
    section.add "poolName", valid_564321
  var valid_564322 = path.getOrDefault("resourceGroupName")
  valid_564322 = validateParameter(valid_564322, JString, required = true,
                                 default = nil)
  if valid_564322 != nil:
    section.add "resourceGroupName", valid_564322
  var valid_564323 = path.getOrDefault("accountName")
  valid_564323 = validateParameter(valid_564323, JString, required = true,
                                 default = nil)
  if valid_564323 != nil:
    section.add "accountName", valid_564323
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564324 = query.getOrDefault("api-version")
  valid_564324 = validateParameter(valid_564324, JString, required = true,
                                 default = newJString("2019-07-01"))
  if valid_564324 != nil:
    section.add "api-version", valid_564324
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564325: Call_MountTargetsList_564316; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List all mount targets associated with the volume
  ## 
  let valid = call_564325.validator(path, query, header, formData, body)
  let scheme = call_564325.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564325.url(scheme.get, call_564325.host, call_564325.base,
                         call_564325.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564325, url, valid)

proc call*(call_564326: Call_MountTargetsList_564316; subscriptionId: string;
          volumeName: string; poolName: string; resourceGroupName: string;
          accountName: string; apiVersion: string = "2019-07-01"): Recallable =
  ## mountTargetsList
  ## List all mount targets associated with the volume
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   volumeName: string (required)
  ##             : The name of the volume
  ##   poolName: string (required)
  ##           : The name of the capacity pool
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   accountName: string (required)
  ##              : The name of the NetApp account
  var path_564327 = newJObject()
  var query_564328 = newJObject()
  add(query_564328, "api-version", newJString(apiVersion))
  add(path_564327, "subscriptionId", newJString(subscriptionId))
  add(path_564327, "volumeName", newJString(volumeName))
  add(path_564327, "poolName", newJString(poolName))
  add(path_564327, "resourceGroupName", newJString(resourceGroupName))
  add(path_564327, "accountName", newJString(accountName))
  result = call_564326.call(path_564327, query_564328, nil, nil, nil)

var mountTargetsList* = Call_MountTargetsList_564316(name: "mountTargetsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.NetApp/netAppAccounts/{accountName}/capacityPools/{poolName}/volumes/{volumeName}/mountTargets",
    validator: validate_MountTargetsList_564317, base: "",
    url: url_MountTargetsList_564318, schemes: {Scheme.Https})
type
  Call_SnapshotsList_564329 = ref object of OpenApiRestCall_563556
proc url_SnapshotsList_564331(protocol: Scheme; host: string; base: string;
                             route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "accountName" in path, "`accountName` is a required path parameter"
  assert "poolName" in path, "`poolName` is a required path parameter"
  assert "volumeName" in path, "`volumeName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.NetApp/netAppAccounts/"),
               (kind: VariableSegment, value: "accountName"),
               (kind: ConstantSegment, value: "/capacityPools/"),
               (kind: VariableSegment, value: "poolName"),
               (kind: ConstantSegment, value: "/volumes/"),
               (kind: VariableSegment, value: "volumeName"),
               (kind: ConstantSegment, value: "/snapshots")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SnapshotsList_564330(path: JsonNode; query: JsonNode; header: JsonNode;
                                  formData: JsonNode; body: JsonNode): JsonNode =
  ## List all snapshots associated with the volume
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   volumeName: JString (required)
  ##             : The name of the volume
  ##   poolName: JString (required)
  ##           : The name of the capacity pool
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   accountName: JString (required)
  ##              : The name of the NetApp account
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564332 = path.getOrDefault("subscriptionId")
  valid_564332 = validateParameter(valid_564332, JString, required = true,
                                 default = nil)
  if valid_564332 != nil:
    section.add "subscriptionId", valid_564332
  var valid_564333 = path.getOrDefault("volumeName")
  valid_564333 = validateParameter(valid_564333, JString, required = true,
                                 default = nil)
  if valid_564333 != nil:
    section.add "volumeName", valid_564333
  var valid_564334 = path.getOrDefault("poolName")
  valid_564334 = validateParameter(valid_564334, JString, required = true,
                                 default = nil)
  if valid_564334 != nil:
    section.add "poolName", valid_564334
  var valid_564335 = path.getOrDefault("resourceGroupName")
  valid_564335 = validateParameter(valid_564335, JString, required = true,
                                 default = nil)
  if valid_564335 != nil:
    section.add "resourceGroupName", valid_564335
  var valid_564336 = path.getOrDefault("accountName")
  valid_564336 = validateParameter(valid_564336, JString, required = true,
                                 default = nil)
  if valid_564336 != nil:
    section.add "accountName", valid_564336
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564337 = query.getOrDefault("api-version")
  valid_564337 = validateParameter(valid_564337, JString, required = true,
                                 default = newJString("2019-07-01"))
  if valid_564337 != nil:
    section.add "api-version", valid_564337
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564338: Call_SnapshotsList_564329; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List all snapshots associated with the volume
  ## 
  let valid = call_564338.validator(path, query, header, formData, body)
  let scheme = call_564338.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564338.url(scheme.get, call_564338.host, call_564338.base,
                         call_564338.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564338, url, valid)

proc call*(call_564339: Call_SnapshotsList_564329; subscriptionId: string;
          volumeName: string; poolName: string; resourceGroupName: string;
          accountName: string; apiVersion: string = "2019-07-01"): Recallable =
  ## snapshotsList
  ## List all snapshots associated with the volume
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   volumeName: string (required)
  ##             : The name of the volume
  ##   poolName: string (required)
  ##           : The name of the capacity pool
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   accountName: string (required)
  ##              : The name of the NetApp account
  var path_564340 = newJObject()
  var query_564341 = newJObject()
  add(query_564341, "api-version", newJString(apiVersion))
  add(path_564340, "subscriptionId", newJString(subscriptionId))
  add(path_564340, "volumeName", newJString(volumeName))
  add(path_564340, "poolName", newJString(poolName))
  add(path_564340, "resourceGroupName", newJString(resourceGroupName))
  add(path_564340, "accountName", newJString(accountName))
  result = call_564339.call(path_564340, query_564341, nil, nil, nil)

var snapshotsList* = Call_SnapshotsList_564329(name: "snapshotsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.NetApp/netAppAccounts/{accountName}/capacityPools/{poolName}/volumes/{volumeName}/snapshots",
    validator: validate_SnapshotsList_564330, base: "", url: url_SnapshotsList_564331,
    schemes: {Scheme.Https})
type
  Call_SnapshotsCreate_564356 = ref object of OpenApiRestCall_563556
proc url_SnapshotsCreate_564358(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "accountName" in path, "`accountName` is a required path parameter"
  assert "poolName" in path, "`poolName` is a required path parameter"
  assert "volumeName" in path, "`volumeName` is a required path parameter"
  assert "snapshotName" in path, "`snapshotName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.NetApp/netAppAccounts/"),
               (kind: VariableSegment, value: "accountName"),
               (kind: ConstantSegment, value: "/capacityPools/"),
               (kind: VariableSegment, value: "poolName"),
               (kind: ConstantSegment, value: "/volumes/"),
               (kind: VariableSegment, value: "volumeName"),
               (kind: ConstantSegment, value: "/snapshots/"),
               (kind: VariableSegment, value: "snapshotName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SnapshotsCreate_564357(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Create the specified snapshot within the given volume
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   volumeName: JString (required)
  ##             : The name of the volume
  ##   poolName: JString (required)
  ##           : The name of the capacity pool
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   snapshotName: JString (required)
  ##               : The name of the mount target
  ##   accountName: JString (required)
  ##              : The name of the NetApp account
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564359 = path.getOrDefault("subscriptionId")
  valid_564359 = validateParameter(valid_564359, JString, required = true,
                                 default = nil)
  if valid_564359 != nil:
    section.add "subscriptionId", valid_564359
  var valid_564360 = path.getOrDefault("volumeName")
  valid_564360 = validateParameter(valid_564360, JString, required = true,
                                 default = nil)
  if valid_564360 != nil:
    section.add "volumeName", valid_564360
  var valid_564361 = path.getOrDefault("poolName")
  valid_564361 = validateParameter(valid_564361, JString, required = true,
                                 default = nil)
  if valid_564361 != nil:
    section.add "poolName", valid_564361
  var valid_564362 = path.getOrDefault("resourceGroupName")
  valid_564362 = validateParameter(valid_564362, JString, required = true,
                                 default = nil)
  if valid_564362 != nil:
    section.add "resourceGroupName", valid_564362
  var valid_564363 = path.getOrDefault("snapshotName")
  valid_564363 = validateParameter(valid_564363, JString, required = true,
                                 default = nil)
  if valid_564363 != nil:
    section.add "snapshotName", valid_564363
  var valid_564364 = path.getOrDefault("accountName")
  valid_564364 = validateParameter(valid_564364, JString, required = true,
                                 default = nil)
  if valid_564364 != nil:
    section.add "accountName", valid_564364
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564365 = query.getOrDefault("api-version")
  valid_564365 = validateParameter(valid_564365, JString, required = true,
                                 default = newJString("2019-07-01"))
  if valid_564365 != nil:
    section.add "api-version", valid_564365
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject (required)
  ##       : Snapshot object supplied in the body of the operation.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564367: Call_SnapshotsCreate_564356; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create the specified snapshot within the given volume
  ## 
  let valid = call_564367.validator(path, query, header, formData, body)
  let scheme = call_564367.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564367.url(scheme.get, call_564367.host, call_564367.base,
                         call_564367.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564367, url, valid)

proc call*(call_564368: Call_SnapshotsCreate_564356; subscriptionId: string;
          volumeName: string; poolName: string; resourceGroupName: string;
          body: JsonNode; snapshotName: string; accountName: string;
          apiVersion: string = "2019-07-01"): Recallable =
  ## snapshotsCreate
  ## Create the specified snapshot within the given volume
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   volumeName: string (required)
  ##             : The name of the volume
  ##   poolName: string (required)
  ##           : The name of the capacity pool
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   body: JObject (required)
  ##       : Snapshot object supplied in the body of the operation.
  ##   snapshotName: string (required)
  ##               : The name of the mount target
  ##   accountName: string (required)
  ##              : The name of the NetApp account
  var path_564369 = newJObject()
  var query_564370 = newJObject()
  var body_564371 = newJObject()
  add(query_564370, "api-version", newJString(apiVersion))
  add(path_564369, "subscriptionId", newJString(subscriptionId))
  add(path_564369, "volumeName", newJString(volumeName))
  add(path_564369, "poolName", newJString(poolName))
  add(path_564369, "resourceGroupName", newJString(resourceGroupName))
  if body != nil:
    body_564371 = body
  add(path_564369, "snapshotName", newJString(snapshotName))
  add(path_564369, "accountName", newJString(accountName))
  result = call_564368.call(path_564369, query_564370, nil, nil, body_564371)

var snapshotsCreate* = Call_SnapshotsCreate_564356(name: "snapshotsCreate",
    meth: HttpMethod.HttpPut, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.NetApp/netAppAccounts/{accountName}/capacityPools/{poolName}/volumes/{volumeName}/snapshots/{snapshotName}",
    validator: validate_SnapshotsCreate_564357, base: "", url: url_SnapshotsCreate_564358,
    schemes: {Scheme.Https})
type
  Call_SnapshotsGet_564342 = ref object of OpenApiRestCall_563556
proc url_SnapshotsGet_564344(protocol: Scheme; host: string; base: string;
                            route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "accountName" in path, "`accountName` is a required path parameter"
  assert "poolName" in path, "`poolName` is a required path parameter"
  assert "volumeName" in path, "`volumeName` is a required path parameter"
  assert "snapshotName" in path, "`snapshotName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.NetApp/netAppAccounts/"),
               (kind: VariableSegment, value: "accountName"),
               (kind: ConstantSegment, value: "/capacityPools/"),
               (kind: VariableSegment, value: "poolName"),
               (kind: ConstantSegment, value: "/volumes/"),
               (kind: VariableSegment, value: "volumeName"),
               (kind: ConstantSegment, value: "/snapshots/"),
               (kind: VariableSegment, value: "snapshotName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SnapshotsGet_564343(path: JsonNode; query: JsonNode; header: JsonNode;
                                 formData: JsonNode; body: JsonNode): JsonNode =
  ## Get details of the specified snapshot
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   volumeName: JString (required)
  ##             : The name of the volume
  ##   poolName: JString (required)
  ##           : The name of the capacity pool
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   snapshotName: JString (required)
  ##               : The name of the mount target
  ##   accountName: JString (required)
  ##              : The name of the NetApp account
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564345 = path.getOrDefault("subscriptionId")
  valid_564345 = validateParameter(valid_564345, JString, required = true,
                                 default = nil)
  if valid_564345 != nil:
    section.add "subscriptionId", valid_564345
  var valid_564346 = path.getOrDefault("volumeName")
  valid_564346 = validateParameter(valid_564346, JString, required = true,
                                 default = nil)
  if valid_564346 != nil:
    section.add "volumeName", valid_564346
  var valid_564347 = path.getOrDefault("poolName")
  valid_564347 = validateParameter(valid_564347, JString, required = true,
                                 default = nil)
  if valid_564347 != nil:
    section.add "poolName", valid_564347
  var valid_564348 = path.getOrDefault("resourceGroupName")
  valid_564348 = validateParameter(valid_564348, JString, required = true,
                                 default = nil)
  if valid_564348 != nil:
    section.add "resourceGroupName", valid_564348
  var valid_564349 = path.getOrDefault("snapshotName")
  valid_564349 = validateParameter(valid_564349, JString, required = true,
                                 default = nil)
  if valid_564349 != nil:
    section.add "snapshotName", valid_564349
  var valid_564350 = path.getOrDefault("accountName")
  valid_564350 = validateParameter(valid_564350, JString, required = true,
                                 default = nil)
  if valid_564350 != nil:
    section.add "accountName", valid_564350
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564351 = query.getOrDefault("api-version")
  valid_564351 = validateParameter(valid_564351, JString, required = true,
                                 default = newJString("2019-07-01"))
  if valid_564351 != nil:
    section.add "api-version", valid_564351
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564352: Call_SnapshotsGet_564342; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get details of the specified snapshot
  ## 
  let valid = call_564352.validator(path, query, header, formData, body)
  let scheme = call_564352.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564352.url(scheme.get, call_564352.host, call_564352.base,
                         call_564352.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564352, url, valid)

proc call*(call_564353: Call_SnapshotsGet_564342; subscriptionId: string;
          volumeName: string; poolName: string; resourceGroupName: string;
          snapshotName: string; accountName: string;
          apiVersion: string = "2019-07-01"): Recallable =
  ## snapshotsGet
  ## Get details of the specified snapshot
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   volumeName: string (required)
  ##             : The name of the volume
  ##   poolName: string (required)
  ##           : The name of the capacity pool
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   snapshotName: string (required)
  ##               : The name of the mount target
  ##   accountName: string (required)
  ##              : The name of the NetApp account
  var path_564354 = newJObject()
  var query_564355 = newJObject()
  add(query_564355, "api-version", newJString(apiVersion))
  add(path_564354, "subscriptionId", newJString(subscriptionId))
  add(path_564354, "volumeName", newJString(volumeName))
  add(path_564354, "poolName", newJString(poolName))
  add(path_564354, "resourceGroupName", newJString(resourceGroupName))
  add(path_564354, "snapshotName", newJString(snapshotName))
  add(path_564354, "accountName", newJString(accountName))
  result = call_564353.call(path_564354, query_564355, nil, nil, nil)

var snapshotsGet* = Call_SnapshotsGet_564342(name: "snapshotsGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.NetApp/netAppAccounts/{accountName}/capacityPools/{poolName}/volumes/{volumeName}/snapshots/{snapshotName}",
    validator: validate_SnapshotsGet_564343, base: "", url: url_SnapshotsGet_564344,
    schemes: {Scheme.Https})
type
  Call_SnapshotsUpdate_564386 = ref object of OpenApiRestCall_563556
proc url_SnapshotsUpdate_564388(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "accountName" in path, "`accountName` is a required path parameter"
  assert "poolName" in path, "`poolName` is a required path parameter"
  assert "volumeName" in path, "`volumeName` is a required path parameter"
  assert "snapshotName" in path, "`snapshotName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.NetApp/netAppAccounts/"),
               (kind: VariableSegment, value: "accountName"),
               (kind: ConstantSegment, value: "/capacityPools/"),
               (kind: VariableSegment, value: "poolName"),
               (kind: ConstantSegment, value: "/volumes/"),
               (kind: VariableSegment, value: "volumeName"),
               (kind: ConstantSegment, value: "/snapshots/"),
               (kind: VariableSegment, value: "snapshotName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SnapshotsUpdate_564387(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Patch a snapshot
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   volumeName: JString (required)
  ##             : The name of the volume
  ##   poolName: JString (required)
  ##           : The name of the capacity pool
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   snapshotName: JString (required)
  ##               : The name of the mount target
  ##   accountName: JString (required)
  ##              : The name of the NetApp account
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564389 = path.getOrDefault("subscriptionId")
  valid_564389 = validateParameter(valid_564389, JString, required = true,
                                 default = nil)
  if valid_564389 != nil:
    section.add "subscriptionId", valid_564389
  var valid_564390 = path.getOrDefault("volumeName")
  valid_564390 = validateParameter(valid_564390, JString, required = true,
                                 default = nil)
  if valid_564390 != nil:
    section.add "volumeName", valid_564390
  var valid_564391 = path.getOrDefault("poolName")
  valid_564391 = validateParameter(valid_564391, JString, required = true,
                                 default = nil)
  if valid_564391 != nil:
    section.add "poolName", valid_564391
  var valid_564392 = path.getOrDefault("resourceGroupName")
  valid_564392 = validateParameter(valid_564392, JString, required = true,
                                 default = nil)
  if valid_564392 != nil:
    section.add "resourceGroupName", valid_564392
  var valid_564393 = path.getOrDefault("snapshotName")
  valid_564393 = validateParameter(valid_564393, JString, required = true,
                                 default = nil)
  if valid_564393 != nil:
    section.add "snapshotName", valid_564393
  var valid_564394 = path.getOrDefault("accountName")
  valid_564394 = validateParameter(valid_564394, JString, required = true,
                                 default = nil)
  if valid_564394 != nil:
    section.add "accountName", valid_564394
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564395 = query.getOrDefault("api-version")
  valid_564395 = validateParameter(valid_564395, JString, required = true,
                                 default = newJString("2019-07-01"))
  if valid_564395 != nil:
    section.add "api-version", valid_564395
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject (required)
  ##       : Snapshot object supplied in the body of the operation.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564397: Call_SnapshotsUpdate_564386; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Patch a snapshot
  ## 
  let valid = call_564397.validator(path, query, header, formData, body)
  let scheme = call_564397.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564397.url(scheme.get, call_564397.host, call_564397.base,
                         call_564397.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564397, url, valid)

proc call*(call_564398: Call_SnapshotsUpdate_564386; subscriptionId: string;
          volumeName: string; poolName: string; resourceGroupName: string;
          body: JsonNode; snapshotName: string; accountName: string;
          apiVersion: string = "2019-07-01"): Recallable =
  ## snapshotsUpdate
  ## Patch a snapshot
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   volumeName: string (required)
  ##             : The name of the volume
  ##   poolName: string (required)
  ##           : The name of the capacity pool
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   body: JObject (required)
  ##       : Snapshot object supplied in the body of the operation.
  ##   snapshotName: string (required)
  ##               : The name of the mount target
  ##   accountName: string (required)
  ##              : The name of the NetApp account
  var path_564399 = newJObject()
  var query_564400 = newJObject()
  var body_564401 = newJObject()
  add(query_564400, "api-version", newJString(apiVersion))
  add(path_564399, "subscriptionId", newJString(subscriptionId))
  add(path_564399, "volumeName", newJString(volumeName))
  add(path_564399, "poolName", newJString(poolName))
  add(path_564399, "resourceGroupName", newJString(resourceGroupName))
  if body != nil:
    body_564401 = body
  add(path_564399, "snapshotName", newJString(snapshotName))
  add(path_564399, "accountName", newJString(accountName))
  result = call_564398.call(path_564399, query_564400, nil, nil, body_564401)

var snapshotsUpdate* = Call_SnapshotsUpdate_564386(name: "snapshotsUpdate",
    meth: HttpMethod.HttpPatch, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.NetApp/netAppAccounts/{accountName}/capacityPools/{poolName}/volumes/{volumeName}/snapshots/{snapshotName}",
    validator: validate_SnapshotsUpdate_564387, base: "", url: url_SnapshotsUpdate_564388,
    schemes: {Scheme.Https})
type
  Call_SnapshotsDelete_564372 = ref object of OpenApiRestCall_563556
proc url_SnapshotsDelete_564374(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "accountName" in path, "`accountName` is a required path parameter"
  assert "poolName" in path, "`poolName` is a required path parameter"
  assert "volumeName" in path, "`volumeName` is a required path parameter"
  assert "snapshotName" in path, "`snapshotName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.NetApp/netAppAccounts/"),
               (kind: VariableSegment, value: "accountName"),
               (kind: ConstantSegment, value: "/capacityPools/"),
               (kind: VariableSegment, value: "poolName"),
               (kind: ConstantSegment, value: "/volumes/"),
               (kind: VariableSegment, value: "volumeName"),
               (kind: ConstantSegment, value: "/snapshots/"),
               (kind: VariableSegment, value: "snapshotName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SnapshotsDelete_564373(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Delete snapshot
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   volumeName: JString (required)
  ##             : The name of the volume
  ##   poolName: JString (required)
  ##           : The name of the capacity pool
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   snapshotName: JString (required)
  ##               : The name of the mount target
  ##   accountName: JString (required)
  ##              : The name of the NetApp account
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564375 = path.getOrDefault("subscriptionId")
  valid_564375 = validateParameter(valid_564375, JString, required = true,
                                 default = nil)
  if valid_564375 != nil:
    section.add "subscriptionId", valid_564375
  var valid_564376 = path.getOrDefault("volumeName")
  valid_564376 = validateParameter(valid_564376, JString, required = true,
                                 default = nil)
  if valid_564376 != nil:
    section.add "volumeName", valid_564376
  var valid_564377 = path.getOrDefault("poolName")
  valid_564377 = validateParameter(valid_564377, JString, required = true,
                                 default = nil)
  if valid_564377 != nil:
    section.add "poolName", valid_564377
  var valid_564378 = path.getOrDefault("resourceGroupName")
  valid_564378 = validateParameter(valid_564378, JString, required = true,
                                 default = nil)
  if valid_564378 != nil:
    section.add "resourceGroupName", valid_564378
  var valid_564379 = path.getOrDefault("snapshotName")
  valid_564379 = validateParameter(valid_564379, JString, required = true,
                                 default = nil)
  if valid_564379 != nil:
    section.add "snapshotName", valid_564379
  var valid_564380 = path.getOrDefault("accountName")
  valid_564380 = validateParameter(valid_564380, JString, required = true,
                                 default = nil)
  if valid_564380 != nil:
    section.add "accountName", valid_564380
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564381 = query.getOrDefault("api-version")
  valid_564381 = validateParameter(valid_564381, JString, required = true,
                                 default = newJString("2019-07-01"))
  if valid_564381 != nil:
    section.add "api-version", valid_564381
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564382: Call_SnapshotsDelete_564372; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete snapshot
  ## 
  let valid = call_564382.validator(path, query, header, formData, body)
  let scheme = call_564382.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564382.url(scheme.get, call_564382.host, call_564382.base,
                         call_564382.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564382, url, valid)

proc call*(call_564383: Call_SnapshotsDelete_564372; subscriptionId: string;
          volumeName: string; poolName: string; resourceGroupName: string;
          snapshotName: string; accountName: string;
          apiVersion: string = "2019-07-01"): Recallable =
  ## snapshotsDelete
  ## Delete snapshot
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   volumeName: string (required)
  ##             : The name of the volume
  ##   poolName: string (required)
  ##           : The name of the capacity pool
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   snapshotName: string (required)
  ##               : The name of the mount target
  ##   accountName: string (required)
  ##              : The name of the NetApp account
  var path_564384 = newJObject()
  var query_564385 = newJObject()
  add(query_564385, "api-version", newJString(apiVersion))
  add(path_564384, "subscriptionId", newJString(subscriptionId))
  add(path_564384, "volumeName", newJString(volumeName))
  add(path_564384, "poolName", newJString(poolName))
  add(path_564384, "resourceGroupName", newJString(resourceGroupName))
  add(path_564384, "snapshotName", newJString(snapshotName))
  add(path_564384, "accountName", newJString(accountName))
  result = call_564383.call(path_564384, query_564385, nil, nil, nil)

var snapshotsDelete* = Call_SnapshotsDelete_564372(name: "snapshotsDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.NetApp/netAppAccounts/{accountName}/capacityPools/{poolName}/volumes/{volumeName}/snapshots/{snapshotName}",
    validator: validate_SnapshotsDelete_564373, base: "", url: url_SnapshotsDelete_564374,
    schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)

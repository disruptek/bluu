
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

  OpenApiRestCall_573658 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_573658](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_573658): Option[Scheme] {.used.} =
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
  macServiceName = "netapp"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_OperationsList_573880 = ref object of OpenApiRestCall_573658
proc url_OperationsList_573882(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_OperationsList_573881(path: JsonNode; query: JsonNode;
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
  var valid_574054 = query.getOrDefault("api-version")
  valid_574054 = validateParameter(valid_574054, JString, required = true,
                                 default = newJString("2019-07-01"))
  if valid_574054 != nil:
    section.add "api-version", valid_574054
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574077: Call_OperationsList_573880; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all of the available Microsoft.NetApp Rest API operations
  ## 
  let valid = call_574077.validator(path, query, header, formData, body)
  let scheme = call_574077.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574077.url(scheme.get, call_574077.host, call_574077.base,
                         call_574077.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574077, url, valid)

proc call*(call_574148: Call_OperationsList_573880;
          apiVersion: string = "2019-07-01"): Recallable =
  ## operationsList
  ## Lists all of the available Microsoft.NetApp Rest API operations
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  var query_574149 = newJObject()
  add(query_574149, "api-version", newJString(apiVersion))
  result = call_574148.call(nil, query_574149, nil, nil, nil)

var operationsList* = Call_OperationsList_573880(name: "operationsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com",
    route: "/providers/Microsoft.NetApp/operations",
    validator: validate_OperationsList_573881, base: "", url: url_OperationsList_573882,
    schemes: {Scheme.Https})
type
  Call_CheckFilePathAvailability_574189 = ref object of OpenApiRestCall_573658
proc url_CheckFilePathAvailability_574191(protocol: Scheme; host: string;
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

proc validate_CheckFilePathAvailability_574190(path: JsonNode; query: JsonNode;
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
  var valid_574206 = path.getOrDefault("subscriptionId")
  valid_574206 = validateParameter(valid_574206, JString, required = true,
                                 default = nil)
  if valid_574206 != nil:
    section.add "subscriptionId", valid_574206
  var valid_574207 = path.getOrDefault("location")
  valid_574207 = validateParameter(valid_574207, JString, required = true,
                                 default = nil)
  if valid_574207 != nil:
    section.add "location", valid_574207
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574208 = query.getOrDefault("api-version")
  valid_574208 = validateParameter(valid_574208, JString, required = true,
                                 default = newJString("2019-07-01"))
  if valid_574208 != nil:
    section.add "api-version", valid_574208
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

proc call*(call_574210: Call_CheckFilePathAvailability_574189; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Check if a file path is available.
  ## 
  let valid = call_574210.validator(path, query, header, formData, body)
  let scheme = call_574210.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574210.url(scheme.get, call_574210.host, call_574210.base,
                         call_574210.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574210, url, valid)

proc call*(call_574211: Call_CheckFilePathAvailability_574189;
          subscriptionId: string; body: JsonNode; location: string;
          apiVersion: string = "2019-07-01"): Recallable =
  ## checkFilePathAvailability
  ## Check if a file path is available.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   body: JObject (required)
  ##       : File path availability request.
  ##   location: string (required)
  ##           : The location
  var path_574212 = newJObject()
  var query_574213 = newJObject()
  var body_574214 = newJObject()
  add(query_574213, "api-version", newJString(apiVersion))
  add(path_574212, "subscriptionId", newJString(subscriptionId))
  if body != nil:
    body_574214 = body
  add(path_574212, "location", newJString(location))
  result = call_574211.call(path_574212, query_574213, nil, nil, body_574214)

var checkFilePathAvailability* = Call_CheckFilePathAvailability_574189(
    name: "checkFilePathAvailability", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.NetApp/locations/{location}/checkFilePathAvailability",
    validator: validate_CheckFilePathAvailability_574190, base: "",
    url: url_CheckFilePathAvailability_574191, schemes: {Scheme.Https})
type
  Call_CheckNameAvailability_574215 = ref object of OpenApiRestCall_573658
proc url_CheckNameAvailability_574217(protocol: Scheme; host: string; base: string;
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

proc validate_CheckNameAvailability_574216(path: JsonNode; query: JsonNode;
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
  var valid_574218 = path.getOrDefault("subscriptionId")
  valid_574218 = validateParameter(valid_574218, JString, required = true,
                                 default = nil)
  if valid_574218 != nil:
    section.add "subscriptionId", valid_574218
  var valid_574219 = path.getOrDefault("location")
  valid_574219 = validateParameter(valid_574219, JString, required = true,
                                 default = nil)
  if valid_574219 != nil:
    section.add "location", valid_574219
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574220 = query.getOrDefault("api-version")
  valid_574220 = validateParameter(valid_574220, JString, required = true,
                                 default = newJString("2019-07-01"))
  if valid_574220 != nil:
    section.add "api-version", valid_574220
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

proc call*(call_574222: Call_CheckNameAvailability_574215; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Check if a resource name is available.
  ## 
  let valid = call_574222.validator(path, query, header, formData, body)
  let scheme = call_574222.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574222.url(scheme.get, call_574222.host, call_574222.base,
                         call_574222.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574222, url, valid)

proc call*(call_574223: Call_CheckNameAvailability_574215; subscriptionId: string;
          body: JsonNode; location: string; apiVersion: string = "2019-07-01"): Recallable =
  ## checkNameAvailability
  ## Check if a resource name is available.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   body: JObject (required)
  ##       : Name availability request.
  ##   location: string (required)
  ##           : The location
  var path_574224 = newJObject()
  var query_574225 = newJObject()
  var body_574226 = newJObject()
  add(query_574225, "api-version", newJString(apiVersion))
  add(path_574224, "subscriptionId", newJString(subscriptionId))
  if body != nil:
    body_574226 = body
  add(path_574224, "location", newJString(location))
  result = call_574223.call(path_574224, query_574225, nil, nil, body_574226)

var checkNameAvailability* = Call_CheckNameAvailability_574215(
    name: "checkNameAvailability", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.NetApp/locations/{location}/checkNameAvailability",
    validator: validate_CheckNameAvailability_574216, base: "",
    url: url_CheckNameAvailability_574217, schemes: {Scheme.Https})
type
  Call_AccountsList_574227 = ref object of OpenApiRestCall_573658
proc url_AccountsList_574229(protocol: Scheme; host: string; base: string;
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

proc validate_AccountsList_574228(path: JsonNode; query: JsonNode; header: JsonNode;
                                 formData: JsonNode; body: JsonNode): JsonNode =
  ## List and describe all NetApp accounts in the resource group
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574230 = path.getOrDefault("resourceGroupName")
  valid_574230 = validateParameter(valid_574230, JString, required = true,
                                 default = nil)
  if valid_574230 != nil:
    section.add "resourceGroupName", valid_574230
  var valid_574231 = path.getOrDefault("subscriptionId")
  valid_574231 = validateParameter(valid_574231, JString, required = true,
                                 default = nil)
  if valid_574231 != nil:
    section.add "subscriptionId", valid_574231
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574232 = query.getOrDefault("api-version")
  valid_574232 = validateParameter(valid_574232, JString, required = true,
                                 default = newJString("2019-07-01"))
  if valid_574232 != nil:
    section.add "api-version", valid_574232
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574233: Call_AccountsList_574227; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List and describe all NetApp accounts in the resource group
  ## 
  let valid = call_574233.validator(path, query, header, formData, body)
  let scheme = call_574233.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574233.url(scheme.get, call_574233.host, call_574233.base,
                         call_574233.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574233, url, valid)

proc call*(call_574234: Call_AccountsList_574227; resourceGroupName: string;
          subscriptionId: string; apiVersion: string = "2019-07-01"): Recallable =
  ## accountsList
  ## List and describe all NetApp accounts in the resource group
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_574235 = newJObject()
  var query_574236 = newJObject()
  add(path_574235, "resourceGroupName", newJString(resourceGroupName))
  add(query_574236, "api-version", newJString(apiVersion))
  add(path_574235, "subscriptionId", newJString(subscriptionId))
  result = call_574234.call(path_574235, query_574236, nil, nil, nil)

var accountsList* = Call_AccountsList_574227(name: "accountsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.NetApp/netAppAccounts",
    validator: validate_AccountsList_574228, base: "", url: url_AccountsList_574229,
    schemes: {Scheme.Https})
type
  Call_AccountsCreateOrUpdate_574248 = ref object of OpenApiRestCall_573658
proc url_AccountsCreateOrUpdate_574250(protocol: Scheme; host: string; base: string;
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

proc validate_AccountsCreateOrUpdate_574249(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create or update the specified NetApp account within the resource group
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   accountName: JString (required)
  ##              : The name of the NetApp account
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574251 = path.getOrDefault("resourceGroupName")
  valid_574251 = validateParameter(valid_574251, JString, required = true,
                                 default = nil)
  if valid_574251 != nil:
    section.add "resourceGroupName", valid_574251
  var valid_574252 = path.getOrDefault("subscriptionId")
  valid_574252 = validateParameter(valid_574252, JString, required = true,
                                 default = nil)
  if valid_574252 != nil:
    section.add "subscriptionId", valid_574252
  var valid_574253 = path.getOrDefault("accountName")
  valid_574253 = validateParameter(valid_574253, JString, required = true,
                                 default = nil)
  if valid_574253 != nil:
    section.add "accountName", valid_574253
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574254 = query.getOrDefault("api-version")
  valid_574254 = validateParameter(valid_574254, JString, required = true,
                                 default = newJString("2019-07-01"))
  if valid_574254 != nil:
    section.add "api-version", valid_574254
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

proc call*(call_574256: Call_AccountsCreateOrUpdate_574248; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create or update the specified NetApp account within the resource group
  ## 
  let valid = call_574256.validator(path, query, header, formData, body)
  let scheme = call_574256.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574256.url(scheme.get, call_574256.host, call_574256.base,
                         call_574256.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574256, url, valid)

proc call*(call_574257: Call_AccountsCreateOrUpdate_574248;
          resourceGroupName: string; subscriptionId: string; body: JsonNode;
          accountName: string; apiVersion: string = "2019-07-01"): Recallable =
  ## accountsCreateOrUpdate
  ## Create or update the specified NetApp account within the resource group
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   body: JObject (required)
  ##       : NetApp Account object supplied in the body of the operation.
  ##   accountName: string (required)
  ##              : The name of the NetApp account
  var path_574258 = newJObject()
  var query_574259 = newJObject()
  var body_574260 = newJObject()
  add(path_574258, "resourceGroupName", newJString(resourceGroupName))
  add(query_574259, "api-version", newJString(apiVersion))
  add(path_574258, "subscriptionId", newJString(subscriptionId))
  if body != nil:
    body_574260 = body
  add(path_574258, "accountName", newJString(accountName))
  result = call_574257.call(path_574258, query_574259, nil, nil, body_574260)

var accountsCreateOrUpdate* = Call_AccountsCreateOrUpdate_574248(
    name: "accountsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.NetApp/netAppAccounts/{accountName}",
    validator: validate_AccountsCreateOrUpdate_574249, base: "",
    url: url_AccountsCreateOrUpdate_574250, schemes: {Scheme.Https})
type
  Call_AccountsGet_574237 = ref object of OpenApiRestCall_573658
proc url_AccountsGet_574239(protocol: Scheme; host: string; base: string;
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

proc validate_AccountsGet_574238(path: JsonNode; query: JsonNode; header: JsonNode;
                                formData: JsonNode; body: JsonNode): JsonNode =
  ## Get the NetApp account
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   accountName: JString (required)
  ##              : The name of the NetApp account
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574240 = path.getOrDefault("resourceGroupName")
  valid_574240 = validateParameter(valid_574240, JString, required = true,
                                 default = nil)
  if valid_574240 != nil:
    section.add "resourceGroupName", valid_574240
  var valid_574241 = path.getOrDefault("subscriptionId")
  valid_574241 = validateParameter(valid_574241, JString, required = true,
                                 default = nil)
  if valid_574241 != nil:
    section.add "subscriptionId", valid_574241
  var valid_574242 = path.getOrDefault("accountName")
  valid_574242 = validateParameter(valid_574242, JString, required = true,
                                 default = nil)
  if valid_574242 != nil:
    section.add "accountName", valid_574242
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574243 = query.getOrDefault("api-version")
  valid_574243 = validateParameter(valid_574243, JString, required = true,
                                 default = newJString("2019-07-01"))
  if valid_574243 != nil:
    section.add "api-version", valid_574243
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574244: Call_AccountsGet_574237; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get the NetApp account
  ## 
  let valid = call_574244.validator(path, query, header, formData, body)
  let scheme = call_574244.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574244.url(scheme.get, call_574244.host, call_574244.base,
                         call_574244.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574244, url, valid)

proc call*(call_574245: Call_AccountsGet_574237; resourceGroupName: string;
          subscriptionId: string; accountName: string;
          apiVersion: string = "2019-07-01"): Recallable =
  ## accountsGet
  ## Get the NetApp account
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   accountName: string (required)
  ##              : The name of the NetApp account
  var path_574246 = newJObject()
  var query_574247 = newJObject()
  add(path_574246, "resourceGroupName", newJString(resourceGroupName))
  add(query_574247, "api-version", newJString(apiVersion))
  add(path_574246, "subscriptionId", newJString(subscriptionId))
  add(path_574246, "accountName", newJString(accountName))
  result = call_574245.call(path_574246, query_574247, nil, nil, nil)

var accountsGet* = Call_AccountsGet_574237(name: "accountsGet",
                                        meth: HttpMethod.HttpGet,
                                        host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.NetApp/netAppAccounts/{accountName}",
                                        validator: validate_AccountsGet_574238,
                                        base: "", url: url_AccountsGet_574239,
                                        schemes: {Scheme.Https})
type
  Call_AccountsUpdate_574272 = ref object of OpenApiRestCall_573658
proc url_AccountsUpdate_574274(protocol: Scheme; host: string; base: string;
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

proc validate_AccountsUpdate_574273(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Patch the specified NetApp account
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   accountName: JString (required)
  ##              : The name of the NetApp account
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574275 = path.getOrDefault("resourceGroupName")
  valid_574275 = validateParameter(valid_574275, JString, required = true,
                                 default = nil)
  if valid_574275 != nil:
    section.add "resourceGroupName", valid_574275
  var valid_574276 = path.getOrDefault("subscriptionId")
  valid_574276 = validateParameter(valid_574276, JString, required = true,
                                 default = nil)
  if valid_574276 != nil:
    section.add "subscriptionId", valid_574276
  var valid_574277 = path.getOrDefault("accountName")
  valid_574277 = validateParameter(valid_574277, JString, required = true,
                                 default = nil)
  if valid_574277 != nil:
    section.add "accountName", valid_574277
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574278 = query.getOrDefault("api-version")
  valid_574278 = validateParameter(valid_574278, JString, required = true,
                                 default = newJString("2019-07-01"))
  if valid_574278 != nil:
    section.add "api-version", valid_574278
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

proc call*(call_574280: Call_AccountsUpdate_574272; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Patch the specified NetApp account
  ## 
  let valid = call_574280.validator(path, query, header, formData, body)
  let scheme = call_574280.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574280.url(scheme.get, call_574280.host, call_574280.base,
                         call_574280.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574280, url, valid)

proc call*(call_574281: Call_AccountsUpdate_574272; resourceGroupName: string;
          subscriptionId: string; body: JsonNode; accountName: string;
          apiVersion: string = "2019-07-01"): Recallable =
  ## accountsUpdate
  ## Patch the specified NetApp account
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   body: JObject (required)
  ##       : NetApp Account object supplied in the body of the operation.
  ##   accountName: string (required)
  ##              : The name of the NetApp account
  var path_574282 = newJObject()
  var query_574283 = newJObject()
  var body_574284 = newJObject()
  add(path_574282, "resourceGroupName", newJString(resourceGroupName))
  add(query_574283, "api-version", newJString(apiVersion))
  add(path_574282, "subscriptionId", newJString(subscriptionId))
  if body != nil:
    body_574284 = body
  add(path_574282, "accountName", newJString(accountName))
  result = call_574281.call(path_574282, query_574283, nil, nil, body_574284)

var accountsUpdate* = Call_AccountsUpdate_574272(name: "accountsUpdate",
    meth: HttpMethod.HttpPatch, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.NetApp/netAppAccounts/{accountName}",
    validator: validate_AccountsUpdate_574273, base: "", url: url_AccountsUpdate_574274,
    schemes: {Scheme.Https})
type
  Call_AccountsDelete_574261 = ref object of OpenApiRestCall_573658
proc url_AccountsDelete_574263(protocol: Scheme; host: string; base: string;
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

proc validate_AccountsDelete_574262(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Delete the specified NetApp account
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   accountName: JString (required)
  ##              : The name of the NetApp account
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574264 = path.getOrDefault("resourceGroupName")
  valid_574264 = validateParameter(valid_574264, JString, required = true,
                                 default = nil)
  if valid_574264 != nil:
    section.add "resourceGroupName", valid_574264
  var valid_574265 = path.getOrDefault("subscriptionId")
  valid_574265 = validateParameter(valid_574265, JString, required = true,
                                 default = nil)
  if valid_574265 != nil:
    section.add "subscriptionId", valid_574265
  var valid_574266 = path.getOrDefault("accountName")
  valid_574266 = validateParameter(valid_574266, JString, required = true,
                                 default = nil)
  if valid_574266 != nil:
    section.add "accountName", valid_574266
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574267 = query.getOrDefault("api-version")
  valid_574267 = validateParameter(valid_574267, JString, required = true,
                                 default = newJString("2019-07-01"))
  if valid_574267 != nil:
    section.add "api-version", valid_574267
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574268: Call_AccountsDelete_574261; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete the specified NetApp account
  ## 
  let valid = call_574268.validator(path, query, header, formData, body)
  let scheme = call_574268.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574268.url(scheme.get, call_574268.host, call_574268.base,
                         call_574268.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574268, url, valid)

proc call*(call_574269: Call_AccountsDelete_574261; resourceGroupName: string;
          subscriptionId: string; accountName: string;
          apiVersion: string = "2019-07-01"): Recallable =
  ## accountsDelete
  ## Delete the specified NetApp account
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   accountName: string (required)
  ##              : The name of the NetApp account
  var path_574270 = newJObject()
  var query_574271 = newJObject()
  add(path_574270, "resourceGroupName", newJString(resourceGroupName))
  add(query_574271, "api-version", newJString(apiVersion))
  add(path_574270, "subscriptionId", newJString(subscriptionId))
  add(path_574270, "accountName", newJString(accountName))
  result = call_574269.call(path_574270, query_574271, nil, nil, nil)

var accountsDelete* = Call_AccountsDelete_574261(name: "accountsDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.NetApp/netAppAccounts/{accountName}",
    validator: validate_AccountsDelete_574262, base: "", url: url_AccountsDelete_574263,
    schemes: {Scheme.Https})
type
  Call_PoolsList_574285 = ref object of OpenApiRestCall_573658
proc url_PoolsList_574287(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_PoolsList_574286(path: JsonNode; query: JsonNode; header: JsonNode;
                              formData: JsonNode; body: JsonNode): JsonNode =
  ## List all capacity pools in the NetApp Account
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   accountName: JString (required)
  ##              : The name of the NetApp account
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574288 = path.getOrDefault("resourceGroupName")
  valid_574288 = validateParameter(valid_574288, JString, required = true,
                                 default = nil)
  if valid_574288 != nil:
    section.add "resourceGroupName", valid_574288
  var valid_574289 = path.getOrDefault("subscriptionId")
  valid_574289 = validateParameter(valid_574289, JString, required = true,
                                 default = nil)
  if valid_574289 != nil:
    section.add "subscriptionId", valid_574289
  var valid_574290 = path.getOrDefault("accountName")
  valid_574290 = validateParameter(valid_574290, JString, required = true,
                                 default = nil)
  if valid_574290 != nil:
    section.add "accountName", valid_574290
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574291 = query.getOrDefault("api-version")
  valid_574291 = validateParameter(valid_574291, JString, required = true,
                                 default = newJString("2019-07-01"))
  if valid_574291 != nil:
    section.add "api-version", valid_574291
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574292: Call_PoolsList_574285; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List all capacity pools in the NetApp Account
  ## 
  let valid = call_574292.validator(path, query, header, formData, body)
  let scheme = call_574292.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574292.url(scheme.get, call_574292.host, call_574292.base,
                         call_574292.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574292, url, valid)

proc call*(call_574293: Call_PoolsList_574285; resourceGroupName: string;
          subscriptionId: string; accountName: string;
          apiVersion: string = "2019-07-01"): Recallable =
  ## poolsList
  ## List all capacity pools in the NetApp Account
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   accountName: string (required)
  ##              : The name of the NetApp account
  var path_574294 = newJObject()
  var query_574295 = newJObject()
  add(path_574294, "resourceGroupName", newJString(resourceGroupName))
  add(query_574295, "api-version", newJString(apiVersion))
  add(path_574294, "subscriptionId", newJString(subscriptionId))
  add(path_574294, "accountName", newJString(accountName))
  result = call_574293.call(path_574294, query_574295, nil, nil, nil)

var poolsList* = Call_PoolsList_574285(name: "poolsList", meth: HttpMethod.HttpGet,
                                    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.NetApp/netAppAccounts/{accountName}/capacityPools",
                                    validator: validate_PoolsList_574286,
                                    base: "", url: url_PoolsList_574287,
                                    schemes: {Scheme.Https})
type
  Call_PoolsCreateOrUpdate_574308 = ref object of OpenApiRestCall_573658
proc url_PoolsCreateOrUpdate_574310(protocol: Scheme; host: string; base: string;
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

proc validate_PoolsCreateOrUpdate_574309(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Create or Update a capacity pool
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   poolName: JString (required)
  ##           : The name of the capacity pool
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   accountName: JString (required)
  ##              : The name of the NetApp account
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `poolName` field"
  var valid_574311 = path.getOrDefault("poolName")
  valid_574311 = validateParameter(valid_574311, JString, required = true,
                                 default = nil)
  if valid_574311 != nil:
    section.add "poolName", valid_574311
  var valid_574312 = path.getOrDefault("resourceGroupName")
  valid_574312 = validateParameter(valid_574312, JString, required = true,
                                 default = nil)
  if valid_574312 != nil:
    section.add "resourceGroupName", valid_574312
  var valid_574313 = path.getOrDefault("subscriptionId")
  valid_574313 = validateParameter(valid_574313, JString, required = true,
                                 default = nil)
  if valid_574313 != nil:
    section.add "subscriptionId", valid_574313
  var valid_574314 = path.getOrDefault("accountName")
  valid_574314 = validateParameter(valid_574314, JString, required = true,
                                 default = nil)
  if valid_574314 != nil:
    section.add "accountName", valid_574314
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574315 = query.getOrDefault("api-version")
  valid_574315 = validateParameter(valid_574315, JString, required = true,
                                 default = newJString("2019-07-01"))
  if valid_574315 != nil:
    section.add "api-version", valid_574315
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

proc call*(call_574317: Call_PoolsCreateOrUpdate_574308; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create or Update a capacity pool
  ## 
  let valid = call_574317.validator(path, query, header, formData, body)
  let scheme = call_574317.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574317.url(scheme.get, call_574317.host, call_574317.base,
                         call_574317.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574317, url, valid)

proc call*(call_574318: Call_PoolsCreateOrUpdate_574308; poolName: string;
          resourceGroupName: string; subscriptionId: string; body: JsonNode;
          accountName: string; apiVersion: string = "2019-07-01"): Recallable =
  ## poolsCreateOrUpdate
  ## Create or Update a capacity pool
  ##   poolName: string (required)
  ##           : The name of the capacity pool
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   body: JObject (required)
  ##       : Capacity pool object supplied in the body of the operation.
  ##   accountName: string (required)
  ##              : The name of the NetApp account
  var path_574319 = newJObject()
  var query_574320 = newJObject()
  var body_574321 = newJObject()
  add(path_574319, "poolName", newJString(poolName))
  add(path_574319, "resourceGroupName", newJString(resourceGroupName))
  add(query_574320, "api-version", newJString(apiVersion))
  add(path_574319, "subscriptionId", newJString(subscriptionId))
  if body != nil:
    body_574321 = body
  add(path_574319, "accountName", newJString(accountName))
  result = call_574318.call(path_574319, query_574320, nil, nil, body_574321)

var poolsCreateOrUpdate* = Call_PoolsCreateOrUpdate_574308(
    name: "poolsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.NetApp/netAppAccounts/{accountName}/capacityPools/{poolName}",
    validator: validate_PoolsCreateOrUpdate_574309, base: "",
    url: url_PoolsCreateOrUpdate_574310, schemes: {Scheme.Https})
type
  Call_PoolsGet_574296 = ref object of OpenApiRestCall_573658
proc url_PoolsGet_574298(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_PoolsGet_574297(path: JsonNode; query: JsonNode; header: JsonNode;
                             formData: JsonNode; body: JsonNode): JsonNode =
  ## Get details of the specified capacity pool
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   poolName: JString (required)
  ##           : The name of the capacity pool
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   accountName: JString (required)
  ##              : The name of the NetApp account
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `poolName` field"
  var valid_574299 = path.getOrDefault("poolName")
  valid_574299 = validateParameter(valid_574299, JString, required = true,
                                 default = nil)
  if valid_574299 != nil:
    section.add "poolName", valid_574299
  var valid_574300 = path.getOrDefault("resourceGroupName")
  valid_574300 = validateParameter(valid_574300, JString, required = true,
                                 default = nil)
  if valid_574300 != nil:
    section.add "resourceGroupName", valid_574300
  var valid_574301 = path.getOrDefault("subscriptionId")
  valid_574301 = validateParameter(valid_574301, JString, required = true,
                                 default = nil)
  if valid_574301 != nil:
    section.add "subscriptionId", valid_574301
  var valid_574302 = path.getOrDefault("accountName")
  valid_574302 = validateParameter(valid_574302, JString, required = true,
                                 default = nil)
  if valid_574302 != nil:
    section.add "accountName", valid_574302
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574303 = query.getOrDefault("api-version")
  valid_574303 = validateParameter(valid_574303, JString, required = true,
                                 default = newJString("2019-07-01"))
  if valid_574303 != nil:
    section.add "api-version", valid_574303
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574304: Call_PoolsGet_574296; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get details of the specified capacity pool
  ## 
  let valid = call_574304.validator(path, query, header, formData, body)
  let scheme = call_574304.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574304.url(scheme.get, call_574304.host, call_574304.base,
                         call_574304.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574304, url, valid)

proc call*(call_574305: Call_PoolsGet_574296; poolName: string;
          resourceGroupName: string; subscriptionId: string; accountName: string;
          apiVersion: string = "2019-07-01"): Recallable =
  ## poolsGet
  ## Get details of the specified capacity pool
  ##   poolName: string (required)
  ##           : The name of the capacity pool
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   accountName: string (required)
  ##              : The name of the NetApp account
  var path_574306 = newJObject()
  var query_574307 = newJObject()
  add(path_574306, "poolName", newJString(poolName))
  add(path_574306, "resourceGroupName", newJString(resourceGroupName))
  add(query_574307, "api-version", newJString(apiVersion))
  add(path_574306, "subscriptionId", newJString(subscriptionId))
  add(path_574306, "accountName", newJString(accountName))
  result = call_574305.call(path_574306, query_574307, nil, nil, nil)

var poolsGet* = Call_PoolsGet_574296(name: "poolsGet", meth: HttpMethod.HttpGet,
                                  host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.NetApp/netAppAccounts/{accountName}/capacityPools/{poolName}",
                                  validator: validate_PoolsGet_574297, base: "",
                                  url: url_PoolsGet_574298,
                                  schemes: {Scheme.Https})
type
  Call_PoolsUpdate_574334 = ref object of OpenApiRestCall_573658
proc url_PoolsUpdate_574336(protocol: Scheme; host: string; base: string;
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

proc validate_PoolsUpdate_574335(path: JsonNode; query: JsonNode; header: JsonNode;
                                formData: JsonNode; body: JsonNode): JsonNode =
  ## Patch the specified capacity pool
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   poolName: JString (required)
  ##           : The name of the capacity pool
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   accountName: JString (required)
  ##              : The name of the NetApp account
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `poolName` field"
  var valid_574337 = path.getOrDefault("poolName")
  valid_574337 = validateParameter(valid_574337, JString, required = true,
                                 default = nil)
  if valid_574337 != nil:
    section.add "poolName", valid_574337
  var valid_574338 = path.getOrDefault("resourceGroupName")
  valid_574338 = validateParameter(valid_574338, JString, required = true,
                                 default = nil)
  if valid_574338 != nil:
    section.add "resourceGroupName", valid_574338
  var valid_574339 = path.getOrDefault("subscriptionId")
  valid_574339 = validateParameter(valid_574339, JString, required = true,
                                 default = nil)
  if valid_574339 != nil:
    section.add "subscriptionId", valid_574339
  var valid_574340 = path.getOrDefault("accountName")
  valid_574340 = validateParameter(valid_574340, JString, required = true,
                                 default = nil)
  if valid_574340 != nil:
    section.add "accountName", valid_574340
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574341 = query.getOrDefault("api-version")
  valid_574341 = validateParameter(valid_574341, JString, required = true,
                                 default = newJString("2019-07-01"))
  if valid_574341 != nil:
    section.add "api-version", valid_574341
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

proc call*(call_574343: Call_PoolsUpdate_574334; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Patch the specified capacity pool
  ## 
  let valid = call_574343.validator(path, query, header, formData, body)
  let scheme = call_574343.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574343.url(scheme.get, call_574343.host, call_574343.base,
                         call_574343.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574343, url, valid)

proc call*(call_574344: Call_PoolsUpdate_574334; poolName: string;
          resourceGroupName: string; subscriptionId: string; body: JsonNode;
          accountName: string; apiVersion: string = "2019-07-01"): Recallable =
  ## poolsUpdate
  ## Patch the specified capacity pool
  ##   poolName: string (required)
  ##           : The name of the capacity pool
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   body: JObject (required)
  ##       : Capacity pool object supplied in the body of the operation.
  ##   accountName: string (required)
  ##              : The name of the NetApp account
  var path_574345 = newJObject()
  var query_574346 = newJObject()
  var body_574347 = newJObject()
  add(path_574345, "poolName", newJString(poolName))
  add(path_574345, "resourceGroupName", newJString(resourceGroupName))
  add(query_574346, "api-version", newJString(apiVersion))
  add(path_574345, "subscriptionId", newJString(subscriptionId))
  if body != nil:
    body_574347 = body
  add(path_574345, "accountName", newJString(accountName))
  result = call_574344.call(path_574345, query_574346, nil, nil, body_574347)

var poolsUpdate* = Call_PoolsUpdate_574334(name: "poolsUpdate",
                                        meth: HttpMethod.HttpPatch,
                                        host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.NetApp/netAppAccounts/{accountName}/capacityPools/{poolName}",
                                        validator: validate_PoolsUpdate_574335,
                                        base: "", url: url_PoolsUpdate_574336,
                                        schemes: {Scheme.Https})
type
  Call_PoolsDelete_574322 = ref object of OpenApiRestCall_573658
proc url_PoolsDelete_574324(protocol: Scheme; host: string; base: string;
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

proc validate_PoolsDelete_574323(path: JsonNode; query: JsonNode; header: JsonNode;
                                formData: JsonNode; body: JsonNode): JsonNode =
  ## Delete the specified capacity pool
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   poolName: JString (required)
  ##           : The name of the capacity pool
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   accountName: JString (required)
  ##              : The name of the NetApp account
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `poolName` field"
  var valid_574325 = path.getOrDefault("poolName")
  valid_574325 = validateParameter(valid_574325, JString, required = true,
                                 default = nil)
  if valid_574325 != nil:
    section.add "poolName", valid_574325
  var valid_574326 = path.getOrDefault("resourceGroupName")
  valid_574326 = validateParameter(valid_574326, JString, required = true,
                                 default = nil)
  if valid_574326 != nil:
    section.add "resourceGroupName", valid_574326
  var valid_574327 = path.getOrDefault("subscriptionId")
  valid_574327 = validateParameter(valid_574327, JString, required = true,
                                 default = nil)
  if valid_574327 != nil:
    section.add "subscriptionId", valid_574327
  var valid_574328 = path.getOrDefault("accountName")
  valid_574328 = validateParameter(valid_574328, JString, required = true,
                                 default = nil)
  if valid_574328 != nil:
    section.add "accountName", valid_574328
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574329 = query.getOrDefault("api-version")
  valid_574329 = validateParameter(valid_574329, JString, required = true,
                                 default = newJString("2019-07-01"))
  if valid_574329 != nil:
    section.add "api-version", valid_574329
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574330: Call_PoolsDelete_574322; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete the specified capacity pool
  ## 
  let valid = call_574330.validator(path, query, header, formData, body)
  let scheme = call_574330.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574330.url(scheme.get, call_574330.host, call_574330.base,
                         call_574330.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574330, url, valid)

proc call*(call_574331: Call_PoolsDelete_574322; poolName: string;
          resourceGroupName: string; subscriptionId: string; accountName: string;
          apiVersion: string = "2019-07-01"): Recallable =
  ## poolsDelete
  ## Delete the specified capacity pool
  ##   poolName: string (required)
  ##           : The name of the capacity pool
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   accountName: string (required)
  ##              : The name of the NetApp account
  var path_574332 = newJObject()
  var query_574333 = newJObject()
  add(path_574332, "poolName", newJString(poolName))
  add(path_574332, "resourceGroupName", newJString(resourceGroupName))
  add(query_574333, "api-version", newJString(apiVersion))
  add(path_574332, "subscriptionId", newJString(subscriptionId))
  add(path_574332, "accountName", newJString(accountName))
  result = call_574331.call(path_574332, query_574333, nil, nil, nil)

var poolsDelete* = Call_PoolsDelete_574322(name: "poolsDelete",
                                        meth: HttpMethod.HttpDelete,
                                        host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.NetApp/netAppAccounts/{accountName}/capacityPools/{poolName}",
                                        validator: validate_PoolsDelete_574323,
                                        base: "", url: url_PoolsDelete_574324,
                                        schemes: {Scheme.Https})
type
  Call_VolumesList_574348 = ref object of OpenApiRestCall_573658
proc url_VolumesList_574350(protocol: Scheme; host: string; base: string;
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

proc validate_VolumesList_574349(path: JsonNode; query: JsonNode; header: JsonNode;
                                formData: JsonNode; body: JsonNode): JsonNode =
  ## List all volumes within the capacity pool
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   poolName: JString (required)
  ##           : The name of the capacity pool
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   accountName: JString (required)
  ##              : The name of the NetApp account
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `poolName` field"
  var valid_574351 = path.getOrDefault("poolName")
  valid_574351 = validateParameter(valid_574351, JString, required = true,
                                 default = nil)
  if valid_574351 != nil:
    section.add "poolName", valid_574351
  var valid_574352 = path.getOrDefault("resourceGroupName")
  valid_574352 = validateParameter(valid_574352, JString, required = true,
                                 default = nil)
  if valid_574352 != nil:
    section.add "resourceGroupName", valid_574352
  var valid_574353 = path.getOrDefault("subscriptionId")
  valid_574353 = validateParameter(valid_574353, JString, required = true,
                                 default = nil)
  if valid_574353 != nil:
    section.add "subscriptionId", valid_574353
  var valid_574354 = path.getOrDefault("accountName")
  valid_574354 = validateParameter(valid_574354, JString, required = true,
                                 default = nil)
  if valid_574354 != nil:
    section.add "accountName", valid_574354
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574355 = query.getOrDefault("api-version")
  valid_574355 = validateParameter(valid_574355, JString, required = true,
                                 default = newJString("2019-07-01"))
  if valid_574355 != nil:
    section.add "api-version", valid_574355
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574356: Call_VolumesList_574348; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List all volumes within the capacity pool
  ## 
  let valid = call_574356.validator(path, query, header, formData, body)
  let scheme = call_574356.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574356.url(scheme.get, call_574356.host, call_574356.base,
                         call_574356.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574356, url, valid)

proc call*(call_574357: Call_VolumesList_574348; poolName: string;
          resourceGroupName: string; subscriptionId: string; accountName: string;
          apiVersion: string = "2019-07-01"): Recallable =
  ## volumesList
  ## List all volumes within the capacity pool
  ##   poolName: string (required)
  ##           : The name of the capacity pool
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   accountName: string (required)
  ##              : The name of the NetApp account
  var path_574358 = newJObject()
  var query_574359 = newJObject()
  add(path_574358, "poolName", newJString(poolName))
  add(path_574358, "resourceGroupName", newJString(resourceGroupName))
  add(query_574359, "api-version", newJString(apiVersion))
  add(path_574358, "subscriptionId", newJString(subscriptionId))
  add(path_574358, "accountName", newJString(accountName))
  result = call_574357.call(path_574358, query_574359, nil, nil, nil)

var volumesList* = Call_VolumesList_574348(name: "volumesList",
                                        meth: HttpMethod.HttpGet,
                                        host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.NetApp/netAppAccounts/{accountName}/capacityPools/{poolName}/volumes",
                                        validator: validate_VolumesList_574349,
                                        base: "", url: url_VolumesList_574350,
                                        schemes: {Scheme.Https})
type
  Call_VolumesCreateOrUpdate_574373 = ref object of OpenApiRestCall_573658
proc url_VolumesCreateOrUpdate_574375(protocol: Scheme; host: string; base: string;
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

proc validate_VolumesCreateOrUpdate_574374(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create or update the specified volume within the capacity pool
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   poolName: JString (required)
  ##           : The name of the capacity pool
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   volumeName: JString (required)
  ##             : The name of the volume
  ##   accountName: JString (required)
  ##              : The name of the NetApp account
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `poolName` field"
  var valid_574376 = path.getOrDefault("poolName")
  valid_574376 = validateParameter(valid_574376, JString, required = true,
                                 default = nil)
  if valid_574376 != nil:
    section.add "poolName", valid_574376
  var valid_574377 = path.getOrDefault("resourceGroupName")
  valid_574377 = validateParameter(valid_574377, JString, required = true,
                                 default = nil)
  if valid_574377 != nil:
    section.add "resourceGroupName", valid_574377
  var valid_574378 = path.getOrDefault("subscriptionId")
  valid_574378 = validateParameter(valid_574378, JString, required = true,
                                 default = nil)
  if valid_574378 != nil:
    section.add "subscriptionId", valid_574378
  var valid_574379 = path.getOrDefault("volumeName")
  valid_574379 = validateParameter(valid_574379, JString, required = true,
                                 default = nil)
  if valid_574379 != nil:
    section.add "volumeName", valid_574379
  var valid_574380 = path.getOrDefault("accountName")
  valid_574380 = validateParameter(valid_574380, JString, required = true,
                                 default = nil)
  if valid_574380 != nil:
    section.add "accountName", valid_574380
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574381 = query.getOrDefault("api-version")
  valid_574381 = validateParameter(valid_574381, JString, required = true,
                                 default = newJString("2019-07-01"))
  if valid_574381 != nil:
    section.add "api-version", valid_574381
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

proc call*(call_574383: Call_VolumesCreateOrUpdate_574373; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create or update the specified volume within the capacity pool
  ## 
  let valid = call_574383.validator(path, query, header, formData, body)
  let scheme = call_574383.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574383.url(scheme.get, call_574383.host, call_574383.base,
                         call_574383.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574383, url, valid)

proc call*(call_574384: Call_VolumesCreateOrUpdate_574373; poolName: string;
          resourceGroupName: string; subscriptionId: string; body: JsonNode;
          volumeName: string; accountName: string; apiVersion: string = "2019-07-01"): Recallable =
  ## volumesCreateOrUpdate
  ## Create or update the specified volume within the capacity pool
  ##   poolName: string (required)
  ##           : The name of the capacity pool
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   body: JObject (required)
  ##       : Volume object supplied in the body of the operation.
  ##   volumeName: string (required)
  ##             : The name of the volume
  ##   accountName: string (required)
  ##              : The name of the NetApp account
  var path_574385 = newJObject()
  var query_574386 = newJObject()
  var body_574387 = newJObject()
  add(path_574385, "poolName", newJString(poolName))
  add(path_574385, "resourceGroupName", newJString(resourceGroupName))
  add(query_574386, "api-version", newJString(apiVersion))
  add(path_574385, "subscriptionId", newJString(subscriptionId))
  if body != nil:
    body_574387 = body
  add(path_574385, "volumeName", newJString(volumeName))
  add(path_574385, "accountName", newJString(accountName))
  result = call_574384.call(path_574385, query_574386, nil, nil, body_574387)

var volumesCreateOrUpdate* = Call_VolumesCreateOrUpdate_574373(
    name: "volumesCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.NetApp/netAppAccounts/{accountName}/capacityPools/{poolName}/volumes/{volumeName}",
    validator: validate_VolumesCreateOrUpdate_574374, base: "",
    url: url_VolumesCreateOrUpdate_574375, schemes: {Scheme.Https})
type
  Call_VolumesGet_574360 = ref object of OpenApiRestCall_573658
proc url_VolumesGet_574362(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_VolumesGet_574361(path: JsonNode; query: JsonNode; header: JsonNode;
                               formData: JsonNode; body: JsonNode): JsonNode =
  ## Get the details of the specified volume
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   poolName: JString (required)
  ##           : The name of the capacity pool
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   volumeName: JString (required)
  ##             : The name of the volume
  ##   accountName: JString (required)
  ##              : The name of the NetApp account
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `poolName` field"
  var valid_574363 = path.getOrDefault("poolName")
  valid_574363 = validateParameter(valid_574363, JString, required = true,
                                 default = nil)
  if valid_574363 != nil:
    section.add "poolName", valid_574363
  var valid_574364 = path.getOrDefault("resourceGroupName")
  valid_574364 = validateParameter(valid_574364, JString, required = true,
                                 default = nil)
  if valid_574364 != nil:
    section.add "resourceGroupName", valid_574364
  var valid_574365 = path.getOrDefault("subscriptionId")
  valid_574365 = validateParameter(valid_574365, JString, required = true,
                                 default = nil)
  if valid_574365 != nil:
    section.add "subscriptionId", valid_574365
  var valid_574366 = path.getOrDefault("volumeName")
  valid_574366 = validateParameter(valid_574366, JString, required = true,
                                 default = nil)
  if valid_574366 != nil:
    section.add "volumeName", valid_574366
  var valid_574367 = path.getOrDefault("accountName")
  valid_574367 = validateParameter(valid_574367, JString, required = true,
                                 default = nil)
  if valid_574367 != nil:
    section.add "accountName", valid_574367
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574368 = query.getOrDefault("api-version")
  valid_574368 = validateParameter(valid_574368, JString, required = true,
                                 default = newJString("2019-07-01"))
  if valid_574368 != nil:
    section.add "api-version", valid_574368
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574369: Call_VolumesGet_574360; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get the details of the specified volume
  ## 
  let valid = call_574369.validator(path, query, header, formData, body)
  let scheme = call_574369.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574369.url(scheme.get, call_574369.host, call_574369.base,
                         call_574369.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574369, url, valid)

proc call*(call_574370: Call_VolumesGet_574360; poolName: string;
          resourceGroupName: string; subscriptionId: string; volumeName: string;
          accountName: string; apiVersion: string = "2019-07-01"): Recallable =
  ## volumesGet
  ## Get the details of the specified volume
  ##   poolName: string (required)
  ##           : The name of the capacity pool
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   volumeName: string (required)
  ##             : The name of the volume
  ##   accountName: string (required)
  ##              : The name of the NetApp account
  var path_574371 = newJObject()
  var query_574372 = newJObject()
  add(path_574371, "poolName", newJString(poolName))
  add(path_574371, "resourceGroupName", newJString(resourceGroupName))
  add(query_574372, "api-version", newJString(apiVersion))
  add(path_574371, "subscriptionId", newJString(subscriptionId))
  add(path_574371, "volumeName", newJString(volumeName))
  add(path_574371, "accountName", newJString(accountName))
  result = call_574370.call(path_574371, query_574372, nil, nil, nil)

var volumesGet* = Call_VolumesGet_574360(name: "volumesGet",
                                      meth: HttpMethod.HttpGet,
                                      host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.NetApp/netAppAccounts/{accountName}/capacityPools/{poolName}/volumes/{volumeName}",
                                      validator: validate_VolumesGet_574361,
                                      base: "", url: url_VolumesGet_574362,
                                      schemes: {Scheme.Https})
type
  Call_VolumesUpdate_574401 = ref object of OpenApiRestCall_573658
proc url_VolumesUpdate_574403(protocol: Scheme; host: string; base: string;
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

proc validate_VolumesUpdate_574402(path: JsonNode; query: JsonNode; header: JsonNode;
                                  formData: JsonNode; body: JsonNode): JsonNode =
  ## Patch the specified volume
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   poolName: JString (required)
  ##           : The name of the capacity pool
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   volumeName: JString (required)
  ##             : The name of the volume
  ##   accountName: JString (required)
  ##              : The name of the NetApp account
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `poolName` field"
  var valid_574404 = path.getOrDefault("poolName")
  valid_574404 = validateParameter(valid_574404, JString, required = true,
                                 default = nil)
  if valid_574404 != nil:
    section.add "poolName", valid_574404
  var valid_574405 = path.getOrDefault("resourceGroupName")
  valid_574405 = validateParameter(valid_574405, JString, required = true,
                                 default = nil)
  if valid_574405 != nil:
    section.add "resourceGroupName", valid_574405
  var valid_574406 = path.getOrDefault("subscriptionId")
  valid_574406 = validateParameter(valid_574406, JString, required = true,
                                 default = nil)
  if valid_574406 != nil:
    section.add "subscriptionId", valid_574406
  var valid_574407 = path.getOrDefault("volumeName")
  valid_574407 = validateParameter(valid_574407, JString, required = true,
                                 default = nil)
  if valid_574407 != nil:
    section.add "volumeName", valid_574407
  var valid_574408 = path.getOrDefault("accountName")
  valid_574408 = validateParameter(valid_574408, JString, required = true,
                                 default = nil)
  if valid_574408 != nil:
    section.add "accountName", valid_574408
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574409 = query.getOrDefault("api-version")
  valid_574409 = validateParameter(valid_574409, JString, required = true,
                                 default = newJString("2019-07-01"))
  if valid_574409 != nil:
    section.add "api-version", valid_574409
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

proc call*(call_574411: Call_VolumesUpdate_574401; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Patch the specified volume
  ## 
  let valid = call_574411.validator(path, query, header, formData, body)
  let scheme = call_574411.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574411.url(scheme.get, call_574411.host, call_574411.base,
                         call_574411.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574411, url, valid)

proc call*(call_574412: Call_VolumesUpdate_574401; poolName: string;
          resourceGroupName: string; subscriptionId: string; body: JsonNode;
          volumeName: string; accountName: string; apiVersion: string = "2019-07-01"): Recallable =
  ## volumesUpdate
  ## Patch the specified volume
  ##   poolName: string (required)
  ##           : The name of the capacity pool
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   body: JObject (required)
  ##       : Volume object supplied in the body of the operation.
  ##   volumeName: string (required)
  ##             : The name of the volume
  ##   accountName: string (required)
  ##              : The name of the NetApp account
  var path_574413 = newJObject()
  var query_574414 = newJObject()
  var body_574415 = newJObject()
  add(path_574413, "poolName", newJString(poolName))
  add(path_574413, "resourceGroupName", newJString(resourceGroupName))
  add(query_574414, "api-version", newJString(apiVersion))
  add(path_574413, "subscriptionId", newJString(subscriptionId))
  if body != nil:
    body_574415 = body
  add(path_574413, "volumeName", newJString(volumeName))
  add(path_574413, "accountName", newJString(accountName))
  result = call_574412.call(path_574413, query_574414, nil, nil, body_574415)

var volumesUpdate* = Call_VolumesUpdate_574401(name: "volumesUpdate",
    meth: HttpMethod.HttpPatch, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.NetApp/netAppAccounts/{accountName}/capacityPools/{poolName}/volumes/{volumeName}",
    validator: validate_VolumesUpdate_574402, base: "", url: url_VolumesUpdate_574403,
    schemes: {Scheme.Https})
type
  Call_VolumesDelete_574388 = ref object of OpenApiRestCall_573658
proc url_VolumesDelete_574390(protocol: Scheme; host: string; base: string;
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

proc validate_VolumesDelete_574389(path: JsonNode; query: JsonNode; header: JsonNode;
                                  formData: JsonNode; body: JsonNode): JsonNode =
  ## Delete the specified volume
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   poolName: JString (required)
  ##           : The name of the capacity pool
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   volumeName: JString (required)
  ##             : The name of the volume
  ##   accountName: JString (required)
  ##              : The name of the NetApp account
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `poolName` field"
  var valid_574391 = path.getOrDefault("poolName")
  valid_574391 = validateParameter(valid_574391, JString, required = true,
                                 default = nil)
  if valid_574391 != nil:
    section.add "poolName", valid_574391
  var valid_574392 = path.getOrDefault("resourceGroupName")
  valid_574392 = validateParameter(valid_574392, JString, required = true,
                                 default = nil)
  if valid_574392 != nil:
    section.add "resourceGroupName", valid_574392
  var valid_574393 = path.getOrDefault("subscriptionId")
  valid_574393 = validateParameter(valid_574393, JString, required = true,
                                 default = nil)
  if valid_574393 != nil:
    section.add "subscriptionId", valid_574393
  var valid_574394 = path.getOrDefault("volumeName")
  valid_574394 = validateParameter(valid_574394, JString, required = true,
                                 default = nil)
  if valid_574394 != nil:
    section.add "volumeName", valid_574394
  var valid_574395 = path.getOrDefault("accountName")
  valid_574395 = validateParameter(valid_574395, JString, required = true,
                                 default = nil)
  if valid_574395 != nil:
    section.add "accountName", valid_574395
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574396 = query.getOrDefault("api-version")
  valid_574396 = validateParameter(valid_574396, JString, required = true,
                                 default = newJString("2019-07-01"))
  if valid_574396 != nil:
    section.add "api-version", valid_574396
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574397: Call_VolumesDelete_574388; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete the specified volume
  ## 
  let valid = call_574397.validator(path, query, header, formData, body)
  let scheme = call_574397.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574397.url(scheme.get, call_574397.host, call_574397.base,
                         call_574397.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574397, url, valid)

proc call*(call_574398: Call_VolumesDelete_574388; poolName: string;
          resourceGroupName: string; subscriptionId: string; volumeName: string;
          accountName: string; apiVersion: string = "2019-07-01"): Recallable =
  ## volumesDelete
  ## Delete the specified volume
  ##   poolName: string (required)
  ##           : The name of the capacity pool
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   volumeName: string (required)
  ##             : The name of the volume
  ##   accountName: string (required)
  ##              : The name of the NetApp account
  var path_574399 = newJObject()
  var query_574400 = newJObject()
  add(path_574399, "poolName", newJString(poolName))
  add(path_574399, "resourceGroupName", newJString(resourceGroupName))
  add(query_574400, "api-version", newJString(apiVersion))
  add(path_574399, "subscriptionId", newJString(subscriptionId))
  add(path_574399, "volumeName", newJString(volumeName))
  add(path_574399, "accountName", newJString(accountName))
  result = call_574398.call(path_574399, query_574400, nil, nil, nil)

var volumesDelete* = Call_VolumesDelete_574388(name: "volumesDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.NetApp/netAppAccounts/{accountName}/capacityPools/{poolName}/volumes/{volumeName}",
    validator: validate_VolumesDelete_574389, base: "", url: url_VolumesDelete_574390,
    schemes: {Scheme.Https})
type
  Call_MountTargetsList_574416 = ref object of OpenApiRestCall_573658
proc url_MountTargetsList_574418(protocol: Scheme; host: string; base: string;
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

proc validate_MountTargetsList_574417(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## List all mount targets associated with the volume
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   poolName: JString (required)
  ##           : The name of the capacity pool
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   volumeName: JString (required)
  ##             : The name of the volume
  ##   accountName: JString (required)
  ##              : The name of the NetApp account
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `poolName` field"
  var valid_574419 = path.getOrDefault("poolName")
  valid_574419 = validateParameter(valid_574419, JString, required = true,
                                 default = nil)
  if valid_574419 != nil:
    section.add "poolName", valid_574419
  var valid_574420 = path.getOrDefault("resourceGroupName")
  valid_574420 = validateParameter(valid_574420, JString, required = true,
                                 default = nil)
  if valid_574420 != nil:
    section.add "resourceGroupName", valid_574420
  var valid_574421 = path.getOrDefault("subscriptionId")
  valid_574421 = validateParameter(valid_574421, JString, required = true,
                                 default = nil)
  if valid_574421 != nil:
    section.add "subscriptionId", valid_574421
  var valid_574422 = path.getOrDefault("volumeName")
  valid_574422 = validateParameter(valid_574422, JString, required = true,
                                 default = nil)
  if valid_574422 != nil:
    section.add "volumeName", valid_574422
  var valid_574423 = path.getOrDefault("accountName")
  valid_574423 = validateParameter(valid_574423, JString, required = true,
                                 default = nil)
  if valid_574423 != nil:
    section.add "accountName", valid_574423
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574424 = query.getOrDefault("api-version")
  valid_574424 = validateParameter(valid_574424, JString, required = true,
                                 default = newJString("2019-07-01"))
  if valid_574424 != nil:
    section.add "api-version", valid_574424
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574425: Call_MountTargetsList_574416; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List all mount targets associated with the volume
  ## 
  let valid = call_574425.validator(path, query, header, formData, body)
  let scheme = call_574425.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574425.url(scheme.get, call_574425.host, call_574425.base,
                         call_574425.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574425, url, valid)

proc call*(call_574426: Call_MountTargetsList_574416; poolName: string;
          resourceGroupName: string; subscriptionId: string; volumeName: string;
          accountName: string; apiVersion: string = "2019-07-01"): Recallable =
  ## mountTargetsList
  ## List all mount targets associated with the volume
  ##   poolName: string (required)
  ##           : The name of the capacity pool
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   volumeName: string (required)
  ##             : The name of the volume
  ##   accountName: string (required)
  ##              : The name of the NetApp account
  var path_574427 = newJObject()
  var query_574428 = newJObject()
  add(path_574427, "poolName", newJString(poolName))
  add(path_574427, "resourceGroupName", newJString(resourceGroupName))
  add(query_574428, "api-version", newJString(apiVersion))
  add(path_574427, "subscriptionId", newJString(subscriptionId))
  add(path_574427, "volumeName", newJString(volumeName))
  add(path_574427, "accountName", newJString(accountName))
  result = call_574426.call(path_574427, query_574428, nil, nil, nil)

var mountTargetsList* = Call_MountTargetsList_574416(name: "mountTargetsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.NetApp/netAppAccounts/{accountName}/capacityPools/{poolName}/volumes/{volumeName}/mountTargets",
    validator: validate_MountTargetsList_574417, base: "",
    url: url_MountTargetsList_574418, schemes: {Scheme.Https})
type
  Call_SnapshotsList_574429 = ref object of OpenApiRestCall_573658
proc url_SnapshotsList_574431(protocol: Scheme; host: string; base: string;
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

proc validate_SnapshotsList_574430(path: JsonNode; query: JsonNode; header: JsonNode;
                                  formData: JsonNode; body: JsonNode): JsonNode =
  ## List all snapshots associated with the volume
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   poolName: JString (required)
  ##           : The name of the capacity pool
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   volumeName: JString (required)
  ##             : The name of the volume
  ##   accountName: JString (required)
  ##              : The name of the NetApp account
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `poolName` field"
  var valid_574432 = path.getOrDefault("poolName")
  valid_574432 = validateParameter(valid_574432, JString, required = true,
                                 default = nil)
  if valid_574432 != nil:
    section.add "poolName", valid_574432
  var valid_574433 = path.getOrDefault("resourceGroupName")
  valid_574433 = validateParameter(valid_574433, JString, required = true,
                                 default = nil)
  if valid_574433 != nil:
    section.add "resourceGroupName", valid_574433
  var valid_574434 = path.getOrDefault("subscriptionId")
  valid_574434 = validateParameter(valid_574434, JString, required = true,
                                 default = nil)
  if valid_574434 != nil:
    section.add "subscriptionId", valid_574434
  var valid_574435 = path.getOrDefault("volumeName")
  valid_574435 = validateParameter(valid_574435, JString, required = true,
                                 default = nil)
  if valid_574435 != nil:
    section.add "volumeName", valid_574435
  var valid_574436 = path.getOrDefault("accountName")
  valid_574436 = validateParameter(valid_574436, JString, required = true,
                                 default = nil)
  if valid_574436 != nil:
    section.add "accountName", valid_574436
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574437 = query.getOrDefault("api-version")
  valid_574437 = validateParameter(valid_574437, JString, required = true,
                                 default = newJString("2019-07-01"))
  if valid_574437 != nil:
    section.add "api-version", valid_574437
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574438: Call_SnapshotsList_574429; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List all snapshots associated with the volume
  ## 
  let valid = call_574438.validator(path, query, header, formData, body)
  let scheme = call_574438.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574438.url(scheme.get, call_574438.host, call_574438.base,
                         call_574438.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574438, url, valid)

proc call*(call_574439: Call_SnapshotsList_574429; poolName: string;
          resourceGroupName: string; subscriptionId: string; volumeName: string;
          accountName: string; apiVersion: string = "2019-07-01"): Recallable =
  ## snapshotsList
  ## List all snapshots associated with the volume
  ##   poolName: string (required)
  ##           : The name of the capacity pool
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   volumeName: string (required)
  ##             : The name of the volume
  ##   accountName: string (required)
  ##              : The name of the NetApp account
  var path_574440 = newJObject()
  var query_574441 = newJObject()
  add(path_574440, "poolName", newJString(poolName))
  add(path_574440, "resourceGroupName", newJString(resourceGroupName))
  add(query_574441, "api-version", newJString(apiVersion))
  add(path_574440, "subscriptionId", newJString(subscriptionId))
  add(path_574440, "volumeName", newJString(volumeName))
  add(path_574440, "accountName", newJString(accountName))
  result = call_574439.call(path_574440, query_574441, nil, nil, nil)

var snapshotsList* = Call_SnapshotsList_574429(name: "snapshotsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.NetApp/netAppAccounts/{accountName}/capacityPools/{poolName}/volumes/{volumeName}/snapshots",
    validator: validate_SnapshotsList_574430, base: "", url: url_SnapshotsList_574431,
    schemes: {Scheme.Https})
type
  Call_SnapshotsCreate_574456 = ref object of OpenApiRestCall_573658
proc url_SnapshotsCreate_574458(protocol: Scheme; host: string; base: string;
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

proc validate_SnapshotsCreate_574457(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Create the specified snapshot within the given volume
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   poolName: JString (required)
  ##           : The name of the capacity pool
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   snapshotName: JString (required)
  ##               : The name of the mount target
  ##   volumeName: JString (required)
  ##             : The name of the volume
  ##   accountName: JString (required)
  ##              : The name of the NetApp account
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `poolName` field"
  var valid_574459 = path.getOrDefault("poolName")
  valid_574459 = validateParameter(valid_574459, JString, required = true,
                                 default = nil)
  if valid_574459 != nil:
    section.add "poolName", valid_574459
  var valid_574460 = path.getOrDefault("resourceGroupName")
  valid_574460 = validateParameter(valid_574460, JString, required = true,
                                 default = nil)
  if valid_574460 != nil:
    section.add "resourceGroupName", valid_574460
  var valid_574461 = path.getOrDefault("subscriptionId")
  valid_574461 = validateParameter(valid_574461, JString, required = true,
                                 default = nil)
  if valid_574461 != nil:
    section.add "subscriptionId", valid_574461
  var valid_574462 = path.getOrDefault("snapshotName")
  valid_574462 = validateParameter(valid_574462, JString, required = true,
                                 default = nil)
  if valid_574462 != nil:
    section.add "snapshotName", valid_574462
  var valid_574463 = path.getOrDefault("volumeName")
  valid_574463 = validateParameter(valid_574463, JString, required = true,
                                 default = nil)
  if valid_574463 != nil:
    section.add "volumeName", valid_574463
  var valid_574464 = path.getOrDefault("accountName")
  valid_574464 = validateParameter(valid_574464, JString, required = true,
                                 default = nil)
  if valid_574464 != nil:
    section.add "accountName", valid_574464
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574465 = query.getOrDefault("api-version")
  valid_574465 = validateParameter(valid_574465, JString, required = true,
                                 default = newJString("2019-07-01"))
  if valid_574465 != nil:
    section.add "api-version", valid_574465
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

proc call*(call_574467: Call_SnapshotsCreate_574456; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create the specified snapshot within the given volume
  ## 
  let valid = call_574467.validator(path, query, header, formData, body)
  let scheme = call_574467.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574467.url(scheme.get, call_574467.host, call_574467.base,
                         call_574467.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574467, url, valid)

proc call*(call_574468: Call_SnapshotsCreate_574456; poolName: string;
          resourceGroupName: string; subscriptionId: string; snapshotName: string;
          body: JsonNode; volumeName: string; accountName: string;
          apiVersion: string = "2019-07-01"): Recallable =
  ## snapshotsCreate
  ## Create the specified snapshot within the given volume
  ##   poolName: string (required)
  ##           : The name of the capacity pool
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   snapshotName: string (required)
  ##               : The name of the mount target
  ##   body: JObject (required)
  ##       : Snapshot object supplied in the body of the operation.
  ##   volumeName: string (required)
  ##             : The name of the volume
  ##   accountName: string (required)
  ##              : The name of the NetApp account
  var path_574469 = newJObject()
  var query_574470 = newJObject()
  var body_574471 = newJObject()
  add(path_574469, "poolName", newJString(poolName))
  add(path_574469, "resourceGroupName", newJString(resourceGroupName))
  add(query_574470, "api-version", newJString(apiVersion))
  add(path_574469, "subscriptionId", newJString(subscriptionId))
  add(path_574469, "snapshotName", newJString(snapshotName))
  if body != nil:
    body_574471 = body
  add(path_574469, "volumeName", newJString(volumeName))
  add(path_574469, "accountName", newJString(accountName))
  result = call_574468.call(path_574469, query_574470, nil, nil, body_574471)

var snapshotsCreate* = Call_SnapshotsCreate_574456(name: "snapshotsCreate",
    meth: HttpMethod.HttpPut, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.NetApp/netAppAccounts/{accountName}/capacityPools/{poolName}/volumes/{volumeName}/snapshots/{snapshotName}",
    validator: validate_SnapshotsCreate_574457, base: "", url: url_SnapshotsCreate_574458,
    schemes: {Scheme.Https})
type
  Call_SnapshotsGet_574442 = ref object of OpenApiRestCall_573658
proc url_SnapshotsGet_574444(protocol: Scheme; host: string; base: string;
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

proc validate_SnapshotsGet_574443(path: JsonNode; query: JsonNode; header: JsonNode;
                                 formData: JsonNode; body: JsonNode): JsonNode =
  ## Get details of the specified snapshot
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   poolName: JString (required)
  ##           : The name of the capacity pool
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   snapshotName: JString (required)
  ##               : The name of the mount target
  ##   volumeName: JString (required)
  ##             : The name of the volume
  ##   accountName: JString (required)
  ##              : The name of the NetApp account
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `poolName` field"
  var valid_574445 = path.getOrDefault("poolName")
  valid_574445 = validateParameter(valid_574445, JString, required = true,
                                 default = nil)
  if valid_574445 != nil:
    section.add "poolName", valid_574445
  var valid_574446 = path.getOrDefault("resourceGroupName")
  valid_574446 = validateParameter(valid_574446, JString, required = true,
                                 default = nil)
  if valid_574446 != nil:
    section.add "resourceGroupName", valid_574446
  var valid_574447 = path.getOrDefault("subscriptionId")
  valid_574447 = validateParameter(valid_574447, JString, required = true,
                                 default = nil)
  if valid_574447 != nil:
    section.add "subscriptionId", valid_574447
  var valid_574448 = path.getOrDefault("snapshotName")
  valid_574448 = validateParameter(valid_574448, JString, required = true,
                                 default = nil)
  if valid_574448 != nil:
    section.add "snapshotName", valid_574448
  var valid_574449 = path.getOrDefault("volumeName")
  valid_574449 = validateParameter(valid_574449, JString, required = true,
                                 default = nil)
  if valid_574449 != nil:
    section.add "volumeName", valid_574449
  var valid_574450 = path.getOrDefault("accountName")
  valid_574450 = validateParameter(valid_574450, JString, required = true,
                                 default = nil)
  if valid_574450 != nil:
    section.add "accountName", valid_574450
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574451 = query.getOrDefault("api-version")
  valid_574451 = validateParameter(valid_574451, JString, required = true,
                                 default = newJString("2019-07-01"))
  if valid_574451 != nil:
    section.add "api-version", valid_574451
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574452: Call_SnapshotsGet_574442; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get details of the specified snapshot
  ## 
  let valid = call_574452.validator(path, query, header, formData, body)
  let scheme = call_574452.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574452.url(scheme.get, call_574452.host, call_574452.base,
                         call_574452.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574452, url, valid)

proc call*(call_574453: Call_SnapshotsGet_574442; poolName: string;
          resourceGroupName: string; subscriptionId: string; snapshotName: string;
          volumeName: string; accountName: string; apiVersion: string = "2019-07-01"): Recallable =
  ## snapshotsGet
  ## Get details of the specified snapshot
  ##   poolName: string (required)
  ##           : The name of the capacity pool
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   snapshotName: string (required)
  ##               : The name of the mount target
  ##   volumeName: string (required)
  ##             : The name of the volume
  ##   accountName: string (required)
  ##              : The name of the NetApp account
  var path_574454 = newJObject()
  var query_574455 = newJObject()
  add(path_574454, "poolName", newJString(poolName))
  add(path_574454, "resourceGroupName", newJString(resourceGroupName))
  add(query_574455, "api-version", newJString(apiVersion))
  add(path_574454, "subscriptionId", newJString(subscriptionId))
  add(path_574454, "snapshotName", newJString(snapshotName))
  add(path_574454, "volumeName", newJString(volumeName))
  add(path_574454, "accountName", newJString(accountName))
  result = call_574453.call(path_574454, query_574455, nil, nil, nil)

var snapshotsGet* = Call_SnapshotsGet_574442(name: "snapshotsGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.NetApp/netAppAccounts/{accountName}/capacityPools/{poolName}/volumes/{volumeName}/snapshots/{snapshotName}",
    validator: validate_SnapshotsGet_574443, base: "", url: url_SnapshotsGet_574444,
    schemes: {Scheme.Https})
type
  Call_SnapshotsUpdate_574486 = ref object of OpenApiRestCall_573658
proc url_SnapshotsUpdate_574488(protocol: Scheme; host: string; base: string;
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

proc validate_SnapshotsUpdate_574487(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Patch a snapshot
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   poolName: JString (required)
  ##           : The name of the capacity pool
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   snapshotName: JString (required)
  ##               : The name of the mount target
  ##   volumeName: JString (required)
  ##             : The name of the volume
  ##   accountName: JString (required)
  ##              : The name of the NetApp account
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `poolName` field"
  var valid_574489 = path.getOrDefault("poolName")
  valid_574489 = validateParameter(valid_574489, JString, required = true,
                                 default = nil)
  if valid_574489 != nil:
    section.add "poolName", valid_574489
  var valid_574490 = path.getOrDefault("resourceGroupName")
  valid_574490 = validateParameter(valid_574490, JString, required = true,
                                 default = nil)
  if valid_574490 != nil:
    section.add "resourceGroupName", valid_574490
  var valid_574491 = path.getOrDefault("subscriptionId")
  valid_574491 = validateParameter(valid_574491, JString, required = true,
                                 default = nil)
  if valid_574491 != nil:
    section.add "subscriptionId", valid_574491
  var valid_574492 = path.getOrDefault("snapshotName")
  valid_574492 = validateParameter(valid_574492, JString, required = true,
                                 default = nil)
  if valid_574492 != nil:
    section.add "snapshotName", valid_574492
  var valid_574493 = path.getOrDefault("volumeName")
  valid_574493 = validateParameter(valid_574493, JString, required = true,
                                 default = nil)
  if valid_574493 != nil:
    section.add "volumeName", valid_574493
  var valid_574494 = path.getOrDefault("accountName")
  valid_574494 = validateParameter(valid_574494, JString, required = true,
                                 default = nil)
  if valid_574494 != nil:
    section.add "accountName", valid_574494
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574495 = query.getOrDefault("api-version")
  valid_574495 = validateParameter(valid_574495, JString, required = true,
                                 default = newJString("2019-07-01"))
  if valid_574495 != nil:
    section.add "api-version", valid_574495
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

proc call*(call_574497: Call_SnapshotsUpdate_574486; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Patch a snapshot
  ## 
  let valid = call_574497.validator(path, query, header, formData, body)
  let scheme = call_574497.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574497.url(scheme.get, call_574497.host, call_574497.base,
                         call_574497.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574497, url, valid)

proc call*(call_574498: Call_SnapshotsUpdate_574486; poolName: string;
          resourceGroupName: string; subscriptionId: string; snapshotName: string;
          body: JsonNode; volumeName: string; accountName: string;
          apiVersion: string = "2019-07-01"): Recallable =
  ## snapshotsUpdate
  ## Patch a snapshot
  ##   poolName: string (required)
  ##           : The name of the capacity pool
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   snapshotName: string (required)
  ##               : The name of the mount target
  ##   body: JObject (required)
  ##       : Snapshot object supplied in the body of the operation.
  ##   volumeName: string (required)
  ##             : The name of the volume
  ##   accountName: string (required)
  ##              : The name of the NetApp account
  var path_574499 = newJObject()
  var query_574500 = newJObject()
  var body_574501 = newJObject()
  add(path_574499, "poolName", newJString(poolName))
  add(path_574499, "resourceGroupName", newJString(resourceGroupName))
  add(query_574500, "api-version", newJString(apiVersion))
  add(path_574499, "subscriptionId", newJString(subscriptionId))
  add(path_574499, "snapshotName", newJString(snapshotName))
  if body != nil:
    body_574501 = body
  add(path_574499, "volumeName", newJString(volumeName))
  add(path_574499, "accountName", newJString(accountName))
  result = call_574498.call(path_574499, query_574500, nil, nil, body_574501)

var snapshotsUpdate* = Call_SnapshotsUpdate_574486(name: "snapshotsUpdate",
    meth: HttpMethod.HttpPatch, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.NetApp/netAppAccounts/{accountName}/capacityPools/{poolName}/volumes/{volumeName}/snapshots/{snapshotName}",
    validator: validate_SnapshotsUpdate_574487, base: "", url: url_SnapshotsUpdate_574488,
    schemes: {Scheme.Https})
type
  Call_SnapshotsDelete_574472 = ref object of OpenApiRestCall_573658
proc url_SnapshotsDelete_574474(protocol: Scheme; host: string; base: string;
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

proc validate_SnapshotsDelete_574473(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Delete snapshot
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   poolName: JString (required)
  ##           : The name of the capacity pool
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   snapshotName: JString (required)
  ##               : The name of the mount target
  ##   volumeName: JString (required)
  ##             : The name of the volume
  ##   accountName: JString (required)
  ##              : The name of the NetApp account
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `poolName` field"
  var valid_574475 = path.getOrDefault("poolName")
  valid_574475 = validateParameter(valid_574475, JString, required = true,
                                 default = nil)
  if valid_574475 != nil:
    section.add "poolName", valid_574475
  var valid_574476 = path.getOrDefault("resourceGroupName")
  valid_574476 = validateParameter(valid_574476, JString, required = true,
                                 default = nil)
  if valid_574476 != nil:
    section.add "resourceGroupName", valid_574476
  var valid_574477 = path.getOrDefault("subscriptionId")
  valid_574477 = validateParameter(valid_574477, JString, required = true,
                                 default = nil)
  if valid_574477 != nil:
    section.add "subscriptionId", valid_574477
  var valid_574478 = path.getOrDefault("snapshotName")
  valid_574478 = validateParameter(valid_574478, JString, required = true,
                                 default = nil)
  if valid_574478 != nil:
    section.add "snapshotName", valid_574478
  var valid_574479 = path.getOrDefault("volumeName")
  valid_574479 = validateParameter(valid_574479, JString, required = true,
                                 default = nil)
  if valid_574479 != nil:
    section.add "volumeName", valid_574479
  var valid_574480 = path.getOrDefault("accountName")
  valid_574480 = validateParameter(valid_574480, JString, required = true,
                                 default = nil)
  if valid_574480 != nil:
    section.add "accountName", valid_574480
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574481 = query.getOrDefault("api-version")
  valid_574481 = validateParameter(valid_574481, JString, required = true,
                                 default = newJString("2019-07-01"))
  if valid_574481 != nil:
    section.add "api-version", valid_574481
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574482: Call_SnapshotsDelete_574472; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete snapshot
  ## 
  let valid = call_574482.validator(path, query, header, formData, body)
  let scheme = call_574482.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574482.url(scheme.get, call_574482.host, call_574482.base,
                         call_574482.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574482, url, valid)

proc call*(call_574483: Call_SnapshotsDelete_574472; poolName: string;
          resourceGroupName: string; subscriptionId: string; snapshotName: string;
          volumeName: string; accountName: string; apiVersion: string = "2019-07-01"): Recallable =
  ## snapshotsDelete
  ## Delete snapshot
  ##   poolName: string (required)
  ##           : The name of the capacity pool
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   snapshotName: string (required)
  ##               : The name of the mount target
  ##   volumeName: string (required)
  ##             : The name of the volume
  ##   accountName: string (required)
  ##              : The name of the NetApp account
  var path_574484 = newJObject()
  var query_574485 = newJObject()
  add(path_574484, "poolName", newJString(poolName))
  add(path_574484, "resourceGroupName", newJString(resourceGroupName))
  add(query_574485, "api-version", newJString(apiVersion))
  add(path_574484, "subscriptionId", newJString(subscriptionId))
  add(path_574484, "snapshotName", newJString(snapshotName))
  add(path_574484, "volumeName", newJString(volumeName))
  add(path_574484, "accountName", newJString(accountName))
  result = call_574483.call(path_574484, query_574485, nil, nil, nil)

var snapshotsDelete* = Call_SnapshotsDelete_574472(name: "snapshotsDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.NetApp/netAppAccounts/{accountName}/capacityPools/{poolName}/volumes/{volumeName}/snapshots/{snapshotName}",
    validator: validate_SnapshotsDelete_574473, base: "", url: url_SnapshotsDelete_574474,
    schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)

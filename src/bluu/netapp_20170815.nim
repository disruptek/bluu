
import
  json, options, hashes, uri, rest, os, uri, httpcore

## auto-generated via openapi macro
## title: Microsoft NetApp
## version: 2017-08-15
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
                                 default = newJString("2017-08-15"))
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
          apiVersion: string = "2017-08-15"): Recallable =
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
  Call_AccountsList_564089 = ref object of OpenApiRestCall_563556
proc url_AccountsList_564091(protocol: Scheme; host: string; base: string;
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

proc validate_AccountsList_564090(path: JsonNode; query: JsonNode; header: JsonNode;
                                 formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all NetApp accounts in the resource group
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
  var valid_564106 = path.getOrDefault("subscriptionId")
  valid_564106 = validateParameter(valid_564106, JString, required = true,
                                 default = nil)
  if valid_564106 != nil:
    section.add "subscriptionId", valid_564106
  var valid_564107 = path.getOrDefault("resourceGroupName")
  valid_564107 = validateParameter(valid_564107, JString, required = true,
                                 default = nil)
  if valid_564107 != nil:
    section.add "resourceGroupName", valid_564107
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564108 = query.getOrDefault("api-version")
  valid_564108 = validateParameter(valid_564108, JString, required = true,
                                 default = newJString("2017-08-15"))
  if valid_564108 != nil:
    section.add "api-version", valid_564108
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564109: Call_AccountsList_564089; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all NetApp accounts in the resource group
  ## 
  let valid = call_564109.validator(path, query, header, formData, body)
  let scheme = call_564109.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564109.url(scheme.get, call_564109.host, call_564109.base,
                         call_564109.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564109, url, valid)

proc call*(call_564110: Call_AccountsList_564089; subscriptionId: string;
          resourceGroupName: string; apiVersion: string = "2017-08-15"): Recallable =
  ## accountsList
  ## Lists all NetApp accounts in the resource group
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  var path_564111 = newJObject()
  var query_564112 = newJObject()
  add(query_564112, "api-version", newJString(apiVersion))
  add(path_564111, "subscriptionId", newJString(subscriptionId))
  add(path_564111, "resourceGroupName", newJString(resourceGroupName))
  result = call_564110.call(path_564111, query_564112, nil, nil, nil)

var accountsList* = Call_AccountsList_564089(name: "accountsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.NetApp/netAppAccounts",
    validator: validate_AccountsList_564090, base: "", url: url_AccountsList_564091,
    schemes: {Scheme.Https})
type
  Call_AccountsCreateOrUpdate_564124 = ref object of OpenApiRestCall_563556
proc url_AccountsCreateOrUpdate_564126(protocol: Scheme; host: string; base: string;
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

proc validate_AccountsCreateOrUpdate_564125(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create or update a NetApp account
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
  var valid_564127 = path.getOrDefault("subscriptionId")
  valid_564127 = validateParameter(valid_564127, JString, required = true,
                                 default = nil)
  if valid_564127 != nil:
    section.add "subscriptionId", valid_564127
  var valid_564128 = path.getOrDefault("resourceGroupName")
  valid_564128 = validateParameter(valid_564128, JString, required = true,
                                 default = nil)
  if valid_564128 != nil:
    section.add "resourceGroupName", valid_564128
  var valid_564129 = path.getOrDefault("accountName")
  valid_564129 = validateParameter(valid_564129, JString, required = true,
                                 default = nil)
  if valid_564129 != nil:
    section.add "accountName", valid_564129
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564130 = query.getOrDefault("api-version")
  valid_564130 = validateParameter(valid_564130, JString, required = true,
                                 default = newJString("2017-08-15"))
  if valid_564130 != nil:
    section.add "api-version", valid_564130
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

proc call*(call_564132: Call_AccountsCreateOrUpdate_564124; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create or update a NetApp account
  ## 
  let valid = call_564132.validator(path, query, header, formData, body)
  let scheme = call_564132.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564132.url(scheme.get, call_564132.host, call_564132.base,
                         call_564132.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564132, url, valid)

proc call*(call_564133: Call_AccountsCreateOrUpdate_564124; subscriptionId: string;
          resourceGroupName: string; body: JsonNode; accountName: string;
          apiVersion: string = "2017-08-15"): Recallable =
  ## accountsCreateOrUpdate
  ## Create or update a NetApp account
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
  var path_564134 = newJObject()
  var query_564135 = newJObject()
  var body_564136 = newJObject()
  add(query_564135, "api-version", newJString(apiVersion))
  add(path_564134, "subscriptionId", newJString(subscriptionId))
  add(path_564134, "resourceGroupName", newJString(resourceGroupName))
  if body != nil:
    body_564136 = body
  add(path_564134, "accountName", newJString(accountName))
  result = call_564133.call(path_564134, query_564135, nil, nil, body_564136)

var accountsCreateOrUpdate* = Call_AccountsCreateOrUpdate_564124(
    name: "accountsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.NetApp/netAppAccounts/{accountName}",
    validator: validate_AccountsCreateOrUpdate_564125, base: "",
    url: url_AccountsCreateOrUpdate_564126, schemes: {Scheme.Https})
type
  Call_AccountsGet_564113 = ref object of OpenApiRestCall_563556
proc url_AccountsGet_564115(protocol: Scheme; host: string; base: string;
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

proc validate_AccountsGet_564114(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_564116 = path.getOrDefault("subscriptionId")
  valid_564116 = validateParameter(valid_564116, JString, required = true,
                                 default = nil)
  if valid_564116 != nil:
    section.add "subscriptionId", valid_564116
  var valid_564117 = path.getOrDefault("resourceGroupName")
  valid_564117 = validateParameter(valid_564117, JString, required = true,
                                 default = nil)
  if valid_564117 != nil:
    section.add "resourceGroupName", valid_564117
  var valid_564118 = path.getOrDefault("accountName")
  valid_564118 = validateParameter(valid_564118, JString, required = true,
                                 default = nil)
  if valid_564118 != nil:
    section.add "accountName", valid_564118
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564119 = query.getOrDefault("api-version")
  valid_564119 = validateParameter(valid_564119, JString, required = true,
                                 default = newJString("2017-08-15"))
  if valid_564119 != nil:
    section.add "api-version", valid_564119
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564120: Call_AccountsGet_564113; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get the NetApp account
  ## 
  let valid = call_564120.validator(path, query, header, formData, body)
  let scheme = call_564120.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564120.url(scheme.get, call_564120.host, call_564120.base,
                         call_564120.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564120, url, valid)

proc call*(call_564121: Call_AccountsGet_564113; subscriptionId: string;
          resourceGroupName: string; accountName: string;
          apiVersion: string = "2017-08-15"): Recallable =
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
  var path_564122 = newJObject()
  var query_564123 = newJObject()
  add(query_564123, "api-version", newJString(apiVersion))
  add(path_564122, "subscriptionId", newJString(subscriptionId))
  add(path_564122, "resourceGroupName", newJString(resourceGroupName))
  add(path_564122, "accountName", newJString(accountName))
  result = call_564121.call(path_564122, query_564123, nil, nil, nil)

var accountsGet* = Call_AccountsGet_564113(name: "accountsGet",
                                        meth: HttpMethod.HttpGet,
                                        host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.NetApp/netAppAccounts/{accountName}",
                                        validator: validate_AccountsGet_564114,
                                        base: "", url: url_AccountsGet_564115,
                                        schemes: {Scheme.Https})
type
  Call_AccountsUpdate_564148 = ref object of OpenApiRestCall_563556
proc url_AccountsUpdate_564150(protocol: Scheme; host: string; base: string;
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

proc validate_AccountsUpdate_564149(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Patch a NetApp account
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
                                 default = newJString("2017-08-15"))
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

proc call*(call_564156: Call_AccountsUpdate_564148; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Patch a NetApp account
  ## 
  let valid = call_564156.validator(path, query, header, formData, body)
  let scheme = call_564156.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564156.url(scheme.get, call_564156.host, call_564156.base,
                         call_564156.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564156, url, valid)

proc call*(call_564157: Call_AccountsUpdate_564148; subscriptionId: string;
          resourceGroupName: string; body: JsonNode; accountName: string;
          apiVersion: string = "2017-08-15"): Recallable =
  ## accountsUpdate
  ## Patch a NetApp account
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

var accountsUpdate* = Call_AccountsUpdate_564148(name: "accountsUpdate",
    meth: HttpMethod.HttpPatch, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.NetApp/netAppAccounts/{accountName}",
    validator: validate_AccountsUpdate_564149, base: "", url: url_AccountsUpdate_564150,
    schemes: {Scheme.Https})
type
  Call_AccountsDelete_564137 = ref object of OpenApiRestCall_563556
proc url_AccountsDelete_564139(protocol: Scheme; host: string; base: string;
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

proc validate_AccountsDelete_564138(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Delete a NetApp account
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
                                 default = newJString("2017-08-15"))
  if valid_564143 != nil:
    section.add "api-version", valid_564143
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564144: Call_AccountsDelete_564137; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete a NetApp account
  ## 
  let valid = call_564144.validator(path, query, header, formData, body)
  let scheme = call_564144.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564144.url(scheme.get, call_564144.host, call_564144.base,
                         call_564144.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564144, url, valid)

proc call*(call_564145: Call_AccountsDelete_564137; subscriptionId: string;
          resourceGroupName: string; accountName: string;
          apiVersion: string = "2017-08-15"): Recallable =
  ## accountsDelete
  ## Delete a NetApp account
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

var accountsDelete* = Call_AccountsDelete_564137(name: "accountsDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.NetApp/netAppAccounts/{accountName}",
    validator: validate_AccountsDelete_564138, base: "", url: url_AccountsDelete_564139,
    schemes: {Scheme.Https})
type
  Call_PoolsList_564161 = ref object of OpenApiRestCall_563556
proc url_PoolsList_564163(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_PoolsList_564162(path: JsonNode; query: JsonNode; header: JsonNode;
                              formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all capacity pools in the NetApp Account
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
                                 default = newJString("2017-08-15"))
  if valid_564167 != nil:
    section.add "api-version", valid_564167
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564168: Call_PoolsList_564161; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all capacity pools in the NetApp Account
  ## 
  let valid = call_564168.validator(path, query, header, formData, body)
  let scheme = call_564168.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564168.url(scheme.get, call_564168.host, call_564168.base,
                         call_564168.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564168, url, valid)

proc call*(call_564169: Call_PoolsList_564161; subscriptionId: string;
          resourceGroupName: string; accountName: string;
          apiVersion: string = "2017-08-15"): Recallable =
  ## poolsList
  ## Lists all capacity pools in the NetApp Account
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

var poolsList* = Call_PoolsList_564161(name: "poolsList", meth: HttpMethod.HttpGet,
                                    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.NetApp/netAppAccounts/{accountName}/capacityPools",
                                    validator: validate_PoolsList_564162,
                                    base: "", url: url_PoolsList_564163,
                                    schemes: {Scheme.Https})
type
  Call_PoolsCreateOrUpdate_564184 = ref object of OpenApiRestCall_563556
proc url_PoolsCreateOrUpdate_564186(protocol: Scheme; host: string; base: string;
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

proc validate_PoolsCreateOrUpdate_564185(path: JsonNode; query: JsonNode;
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
  var valid_564187 = path.getOrDefault("subscriptionId")
  valid_564187 = validateParameter(valid_564187, JString, required = true,
                                 default = nil)
  if valid_564187 != nil:
    section.add "subscriptionId", valid_564187
  var valid_564188 = path.getOrDefault("poolName")
  valid_564188 = validateParameter(valid_564188, JString, required = true,
                                 default = nil)
  if valid_564188 != nil:
    section.add "poolName", valid_564188
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
                                 default = newJString("2017-08-15"))
  if valid_564191 != nil:
    section.add "api-version", valid_564191
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

proc call*(call_564193: Call_PoolsCreateOrUpdate_564184; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create or Update a capacity pool
  ## 
  let valid = call_564193.validator(path, query, header, formData, body)
  let scheme = call_564193.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564193.url(scheme.get, call_564193.host, call_564193.base,
                         call_564193.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564193, url, valid)

proc call*(call_564194: Call_PoolsCreateOrUpdate_564184; subscriptionId: string;
          poolName: string; resourceGroupName: string; body: JsonNode;
          accountName: string; apiVersion: string = "2017-08-15"): Recallable =
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
  var path_564195 = newJObject()
  var query_564196 = newJObject()
  var body_564197 = newJObject()
  add(query_564196, "api-version", newJString(apiVersion))
  add(path_564195, "subscriptionId", newJString(subscriptionId))
  add(path_564195, "poolName", newJString(poolName))
  add(path_564195, "resourceGroupName", newJString(resourceGroupName))
  if body != nil:
    body_564197 = body
  add(path_564195, "accountName", newJString(accountName))
  result = call_564194.call(path_564195, query_564196, nil, nil, body_564197)

var poolsCreateOrUpdate* = Call_PoolsCreateOrUpdate_564184(
    name: "poolsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.NetApp/netAppAccounts/{accountName}/capacityPools/{poolName}",
    validator: validate_PoolsCreateOrUpdate_564185, base: "",
    url: url_PoolsCreateOrUpdate_564186, schemes: {Scheme.Https})
type
  Call_PoolsGet_564172 = ref object of OpenApiRestCall_563556
proc url_PoolsGet_564174(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_PoolsGet_564173(path: JsonNode; query: JsonNode; header: JsonNode;
                             formData: JsonNode; body: JsonNode): JsonNode =
  ## Get a capacity pool
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
  var valid_564175 = path.getOrDefault("subscriptionId")
  valid_564175 = validateParameter(valid_564175, JString, required = true,
                                 default = nil)
  if valid_564175 != nil:
    section.add "subscriptionId", valid_564175
  var valid_564176 = path.getOrDefault("poolName")
  valid_564176 = validateParameter(valid_564176, JString, required = true,
                                 default = nil)
  if valid_564176 != nil:
    section.add "poolName", valid_564176
  var valid_564177 = path.getOrDefault("resourceGroupName")
  valid_564177 = validateParameter(valid_564177, JString, required = true,
                                 default = nil)
  if valid_564177 != nil:
    section.add "resourceGroupName", valid_564177
  var valid_564178 = path.getOrDefault("accountName")
  valid_564178 = validateParameter(valid_564178, JString, required = true,
                                 default = nil)
  if valid_564178 != nil:
    section.add "accountName", valid_564178
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564179 = query.getOrDefault("api-version")
  valid_564179 = validateParameter(valid_564179, JString, required = true,
                                 default = newJString("2017-08-15"))
  if valid_564179 != nil:
    section.add "api-version", valid_564179
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564180: Call_PoolsGet_564172; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get a capacity pool
  ## 
  let valid = call_564180.validator(path, query, header, formData, body)
  let scheme = call_564180.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564180.url(scheme.get, call_564180.host, call_564180.base,
                         call_564180.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564180, url, valid)

proc call*(call_564181: Call_PoolsGet_564172; subscriptionId: string;
          poolName: string; resourceGroupName: string; accountName: string;
          apiVersion: string = "2017-08-15"): Recallable =
  ## poolsGet
  ## Get a capacity pool
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
  var path_564182 = newJObject()
  var query_564183 = newJObject()
  add(query_564183, "api-version", newJString(apiVersion))
  add(path_564182, "subscriptionId", newJString(subscriptionId))
  add(path_564182, "poolName", newJString(poolName))
  add(path_564182, "resourceGroupName", newJString(resourceGroupName))
  add(path_564182, "accountName", newJString(accountName))
  result = call_564181.call(path_564182, query_564183, nil, nil, nil)

var poolsGet* = Call_PoolsGet_564172(name: "poolsGet", meth: HttpMethod.HttpGet,
                                  host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.NetApp/netAppAccounts/{accountName}/capacityPools/{poolName}",
                                  validator: validate_PoolsGet_564173, base: "",
                                  url: url_PoolsGet_564174,
                                  schemes: {Scheme.Https})
type
  Call_PoolsUpdate_564210 = ref object of OpenApiRestCall_563556
proc url_PoolsUpdate_564212(protocol: Scheme; host: string; base: string;
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

proc validate_PoolsUpdate_564211(path: JsonNode; query: JsonNode; header: JsonNode;
                                formData: JsonNode; body: JsonNode): JsonNode =
  ## Patch a capacity pool
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
  var valid_564213 = path.getOrDefault("subscriptionId")
  valid_564213 = validateParameter(valid_564213, JString, required = true,
                                 default = nil)
  if valid_564213 != nil:
    section.add "subscriptionId", valid_564213
  var valid_564214 = path.getOrDefault("poolName")
  valid_564214 = validateParameter(valid_564214, JString, required = true,
                                 default = nil)
  if valid_564214 != nil:
    section.add "poolName", valid_564214
  var valid_564215 = path.getOrDefault("resourceGroupName")
  valid_564215 = validateParameter(valid_564215, JString, required = true,
                                 default = nil)
  if valid_564215 != nil:
    section.add "resourceGroupName", valid_564215
  var valid_564216 = path.getOrDefault("accountName")
  valid_564216 = validateParameter(valid_564216, JString, required = true,
                                 default = nil)
  if valid_564216 != nil:
    section.add "accountName", valid_564216
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564217 = query.getOrDefault("api-version")
  valid_564217 = validateParameter(valid_564217, JString, required = true,
                                 default = newJString("2017-08-15"))
  if valid_564217 != nil:
    section.add "api-version", valid_564217
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

proc call*(call_564219: Call_PoolsUpdate_564210; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Patch a capacity pool
  ## 
  let valid = call_564219.validator(path, query, header, formData, body)
  let scheme = call_564219.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564219.url(scheme.get, call_564219.host, call_564219.base,
                         call_564219.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564219, url, valid)

proc call*(call_564220: Call_PoolsUpdate_564210; subscriptionId: string;
          poolName: string; resourceGroupName: string; body: JsonNode;
          accountName: string; apiVersion: string = "2017-08-15"): Recallable =
  ## poolsUpdate
  ## Patch a capacity pool
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
  var path_564221 = newJObject()
  var query_564222 = newJObject()
  var body_564223 = newJObject()
  add(query_564222, "api-version", newJString(apiVersion))
  add(path_564221, "subscriptionId", newJString(subscriptionId))
  add(path_564221, "poolName", newJString(poolName))
  add(path_564221, "resourceGroupName", newJString(resourceGroupName))
  if body != nil:
    body_564223 = body
  add(path_564221, "accountName", newJString(accountName))
  result = call_564220.call(path_564221, query_564222, nil, nil, body_564223)

var poolsUpdate* = Call_PoolsUpdate_564210(name: "poolsUpdate",
                                        meth: HttpMethod.HttpPatch,
                                        host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.NetApp/netAppAccounts/{accountName}/capacityPools/{poolName}",
                                        validator: validate_PoolsUpdate_564211,
                                        base: "", url: url_PoolsUpdate_564212,
                                        schemes: {Scheme.Https})
type
  Call_PoolsDelete_564198 = ref object of OpenApiRestCall_563556
proc url_PoolsDelete_564200(protocol: Scheme; host: string; base: string;
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

proc validate_PoolsDelete_564199(path: JsonNode; query: JsonNode; header: JsonNode;
                                formData: JsonNode; body: JsonNode): JsonNode =
  ## Delete a capacity pool
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
  var valid_564201 = path.getOrDefault("subscriptionId")
  valid_564201 = validateParameter(valid_564201, JString, required = true,
                                 default = nil)
  if valid_564201 != nil:
    section.add "subscriptionId", valid_564201
  var valid_564202 = path.getOrDefault("poolName")
  valid_564202 = validateParameter(valid_564202, JString, required = true,
                                 default = nil)
  if valid_564202 != nil:
    section.add "poolName", valid_564202
  var valid_564203 = path.getOrDefault("resourceGroupName")
  valid_564203 = validateParameter(valid_564203, JString, required = true,
                                 default = nil)
  if valid_564203 != nil:
    section.add "resourceGroupName", valid_564203
  var valid_564204 = path.getOrDefault("accountName")
  valid_564204 = validateParameter(valid_564204, JString, required = true,
                                 default = nil)
  if valid_564204 != nil:
    section.add "accountName", valid_564204
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564205 = query.getOrDefault("api-version")
  valid_564205 = validateParameter(valid_564205, JString, required = true,
                                 default = newJString("2017-08-15"))
  if valid_564205 != nil:
    section.add "api-version", valid_564205
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564206: Call_PoolsDelete_564198; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete a capacity pool
  ## 
  let valid = call_564206.validator(path, query, header, formData, body)
  let scheme = call_564206.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564206.url(scheme.get, call_564206.host, call_564206.base,
                         call_564206.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564206, url, valid)

proc call*(call_564207: Call_PoolsDelete_564198; subscriptionId: string;
          poolName: string; resourceGroupName: string; accountName: string;
          apiVersion: string = "2017-08-15"): Recallable =
  ## poolsDelete
  ## Delete a capacity pool
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
  var path_564208 = newJObject()
  var query_564209 = newJObject()
  add(query_564209, "api-version", newJString(apiVersion))
  add(path_564208, "subscriptionId", newJString(subscriptionId))
  add(path_564208, "poolName", newJString(poolName))
  add(path_564208, "resourceGroupName", newJString(resourceGroupName))
  add(path_564208, "accountName", newJString(accountName))
  result = call_564207.call(path_564208, query_564209, nil, nil, nil)

var poolsDelete* = Call_PoolsDelete_564198(name: "poolsDelete",
                                        meth: HttpMethod.HttpDelete,
                                        host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.NetApp/netAppAccounts/{accountName}/capacityPools/{poolName}",
                                        validator: validate_PoolsDelete_564199,
                                        base: "", url: url_PoolsDelete_564200,
                                        schemes: {Scheme.Https})
type
  Call_VolumesList_564224 = ref object of OpenApiRestCall_563556
proc url_VolumesList_564226(protocol: Scheme; host: string; base: string;
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

proc validate_VolumesList_564225(path: JsonNode; query: JsonNode; header: JsonNode;
                                formData: JsonNode; body: JsonNode): JsonNode =
  ## List volumes
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
  var valid_564227 = path.getOrDefault("subscriptionId")
  valid_564227 = validateParameter(valid_564227, JString, required = true,
                                 default = nil)
  if valid_564227 != nil:
    section.add "subscriptionId", valid_564227
  var valid_564228 = path.getOrDefault("poolName")
  valid_564228 = validateParameter(valid_564228, JString, required = true,
                                 default = nil)
  if valid_564228 != nil:
    section.add "poolName", valid_564228
  var valid_564229 = path.getOrDefault("resourceGroupName")
  valid_564229 = validateParameter(valid_564229, JString, required = true,
                                 default = nil)
  if valid_564229 != nil:
    section.add "resourceGroupName", valid_564229
  var valid_564230 = path.getOrDefault("accountName")
  valid_564230 = validateParameter(valid_564230, JString, required = true,
                                 default = nil)
  if valid_564230 != nil:
    section.add "accountName", valid_564230
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564231 = query.getOrDefault("api-version")
  valid_564231 = validateParameter(valid_564231, JString, required = true,
                                 default = newJString("2017-08-15"))
  if valid_564231 != nil:
    section.add "api-version", valid_564231
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564232: Call_VolumesList_564224; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List volumes
  ## 
  let valid = call_564232.validator(path, query, header, formData, body)
  let scheme = call_564232.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564232.url(scheme.get, call_564232.host, call_564232.base,
                         call_564232.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564232, url, valid)

proc call*(call_564233: Call_VolumesList_564224; subscriptionId: string;
          poolName: string; resourceGroupName: string; accountName: string;
          apiVersion: string = "2017-08-15"): Recallable =
  ## volumesList
  ## List volumes
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
  var path_564234 = newJObject()
  var query_564235 = newJObject()
  add(query_564235, "api-version", newJString(apiVersion))
  add(path_564234, "subscriptionId", newJString(subscriptionId))
  add(path_564234, "poolName", newJString(poolName))
  add(path_564234, "resourceGroupName", newJString(resourceGroupName))
  add(path_564234, "accountName", newJString(accountName))
  result = call_564233.call(path_564234, query_564235, nil, nil, nil)

var volumesList* = Call_VolumesList_564224(name: "volumesList",
                                        meth: HttpMethod.HttpGet,
                                        host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.NetApp/netAppAccounts/{accountName}/capacityPools/{poolName}/volumes",
                                        validator: validate_VolumesList_564225,
                                        base: "", url: url_VolumesList_564226,
                                        schemes: {Scheme.Https})
type
  Call_VolumesCreateOrUpdate_564249 = ref object of OpenApiRestCall_563556
proc url_VolumesCreateOrUpdate_564251(protocol: Scheme; host: string; base: string;
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

proc validate_VolumesCreateOrUpdate_564250(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create or update a volume
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
  var valid_564252 = path.getOrDefault("subscriptionId")
  valid_564252 = validateParameter(valid_564252, JString, required = true,
                                 default = nil)
  if valid_564252 != nil:
    section.add "subscriptionId", valid_564252
  var valid_564253 = path.getOrDefault("volumeName")
  valid_564253 = validateParameter(valid_564253, JString, required = true,
                                 default = nil)
  if valid_564253 != nil:
    section.add "volumeName", valid_564253
  var valid_564254 = path.getOrDefault("poolName")
  valid_564254 = validateParameter(valid_564254, JString, required = true,
                                 default = nil)
  if valid_564254 != nil:
    section.add "poolName", valid_564254
  var valid_564255 = path.getOrDefault("resourceGroupName")
  valid_564255 = validateParameter(valid_564255, JString, required = true,
                                 default = nil)
  if valid_564255 != nil:
    section.add "resourceGroupName", valid_564255
  var valid_564256 = path.getOrDefault("accountName")
  valid_564256 = validateParameter(valid_564256, JString, required = true,
                                 default = nil)
  if valid_564256 != nil:
    section.add "accountName", valid_564256
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564257 = query.getOrDefault("api-version")
  valid_564257 = validateParameter(valid_564257, JString, required = true,
                                 default = newJString("2017-08-15"))
  if valid_564257 != nil:
    section.add "api-version", valid_564257
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

proc call*(call_564259: Call_VolumesCreateOrUpdate_564249; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create or update a volume
  ## 
  let valid = call_564259.validator(path, query, header, formData, body)
  let scheme = call_564259.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564259.url(scheme.get, call_564259.host, call_564259.base,
                         call_564259.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564259, url, valid)

proc call*(call_564260: Call_VolumesCreateOrUpdate_564249; subscriptionId: string;
          volumeName: string; poolName: string; resourceGroupName: string;
          body: JsonNode; accountName: string; apiVersion: string = "2017-08-15"): Recallable =
  ## volumesCreateOrUpdate
  ## Create or update a volume
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
  var path_564261 = newJObject()
  var query_564262 = newJObject()
  var body_564263 = newJObject()
  add(query_564262, "api-version", newJString(apiVersion))
  add(path_564261, "subscriptionId", newJString(subscriptionId))
  add(path_564261, "volumeName", newJString(volumeName))
  add(path_564261, "poolName", newJString(poolName))
  add(path_564261, "resourceGroupName", newJString(resourceGroupName))
  if body != nil:
    body_564263 = body
  add(path_564261, "accountName", newJString(accountName))
  result = call_564260.call(path_564261, query_564262, nil, nil, body_564263)

var volumesCreateOrUpdate* = Call_VolumesCreateOrUpdate_564249(
    name: "volumesCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.NetApp/netAppAccounts/{accountName}/capacityPools/{poolName}/volumes/{volumeName}",
    validator: validate_VolumesCreateOrUpdate_564250, base: "",
    url: url_VolumesCreateOrUpdate_564251, schemes: {Scheme.Https})
type
  Call_VolumesGet_564236 = ref object of OpenApiRestCall_563556
proc url_VolumesGet_564238(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_VolumesGet_564237(path: JsonNode; query: JsonNode; header: JsonNode;
                               formData: JsonNode; body: JsonNode): JsonNode =
  ## Get a volume
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
  var valid_564239 = path.getOrDefault("subscriptionId")
  valid_564239 = validateParameter(valid_564239, JString, required = true,
                                 default = nil)
  if valid_564239 != nil:
    section.add "subscriptionId", valid_564239
  var valid_564240 = path.getOrDefault("volumeName")
  valid_564240 = validateParameter(valid_564240, JString, required = true,
                                 default = nil)
  if valid_564240 != nil:
    section.add "volumeName", valid_564240
  var valid_564241 = path.getOrDefault("poolName")
  valid_564241 = validateParameter(valid_564241, JString, required = true,
                                 default = nil)
  if valid_564241 != nil:
    section.add "poolName", valid_564241
  var valid_564242 = path.getOrDefault("resourceGroupName")
  valid_564242 = validateParameter(valid_564242, JString, required = true,
                                 default = nil)
  if valid_564242 != nil:
    section.add "resourceGroupName", valid_564242
  var valid_564243 = path.getOrDefault("accountName")
  valid_564243 = validateParameter(valid_564243, JString, required = true,
                                 default = nil)
  if valid_564243 != nil:
    section.add "accountName", valid_564243
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564244 = query.getOrDefault("api-version")
  valid_564244 = validateParameter(valid_564244, JString, required = true,
                                 default = newJString("2017-08-15"))
  if valid_564244 != nil:
    section.add "api-version", valid_564244
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564245: Call_VolumesGet_564236; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get a volume
  ## 
  let valid = call_564245.validator(path, query, header, formData, body)
  let scheme = call_564245.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564245.url(scheme.get, call_564245.host, call_564245.base,
                         call_564245.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564245, url, valid)

proc call*(call_564246: Call_VolumesGet_564236; subscriptionId: string;
          volumeName: string; poolName: string; resourceGroupName: string;
          accountName: string; apiVersion: string = "2017-08-15"): Recallable =
  ## volumesGet
  ## Get a volume
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
  var path_564247 = newJObject()
  var query_564248 = newJObject()
  add(query_564248, "api-version", newJString(apiVersion))
  add(path_564247, "subscriptionId", newJString(subscriptionId))
  add(path_564247, "volumeName", newJString(volumeName))
  add(path_564247, "poolName", newJString(poolName))
  add(path_564247, "resourceGroupName", newJString(resourceGroupName))
  add(path_564247, "accountName", newJString(accountName))
  result = call_564246.call(path_564247, query_564248, nil, nil, nil)

var volumesGet* = Call_VolumesGet_564236(name: "volumesGet",
                                      meth: HttpMethod.HttpGet,
                                      host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.NetApp/netAppAccounts/{accountName}/capacityPools/{poolName}/volumes/{volumeName}",
                                      validator: validate_VolumesGet_564237,
                                      base: "", url: url_VolumesGet_564238,
                                      schemes: {Scheme.Https})
type
  Call_VolumesUpdate_564277 = ref object of OpenApiRestCall_563556
proc url_VolumesUpdate_564279(protocol: Scheme; host: string; base: string;
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

proc validate_VolumesUpdate_564278(path: JsonNode; query: JsonNode; header: JsonNode;
                                  formData: JsonNode; body: JsonNode): JsonNode =
  ## Patch a volume
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
  var valid_564280 = path.getOrDefault("subscriptionId")
  valid_564280 = validateParameter(valid_564280, JString, required = true,
                                 default = nil)
  if valid_564280 != nil:
    section.add "subscriptionId", valid_564280
  var valid_564281 = path.getOrDefault("volumeName")
  valid_564281 = validateParameter(valid_564281, JString, required = true,
                                 default = nil)
  if valid_564281 != nil:
    section.add "volumeName", valid_564281
  var valid_564282 = path.getOrDefault("poolName")
  valid_564282 = validateParameter(valid_564282, JString, required = true,
                                 default = nil)
  if valid_564282 != nil:
    section.add "poolName", valid_564282
  var valid_564283 = path.getOrDefault("resourceGroupName")
  valid_564283 = validateParameter(valid_564283, JString, required = true,
                                 default = nil)
  if valid_564283 != nil:
    section.add "resourceGroupName", valid_564283
  var valid_564284 = path.getOrDefault("accountName")
  valid_564284 = validateParameter(valid_564284, JString, required = true,
                                 default = nil)
  if valid_564284 != nil:
    section.add "accountName", valid_564284
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564285 = query.getOrDefault("api-version")
  valid_564285 = validateParameter(valid_564285, JString, required = true,
                                 default = newJString("2017-08-15"))
  if valid_564285 != nil:
    section.add "api-version", valid_564285
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

proc call*(call_564287: Call_VolumesUpdate_564277; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Patch a volume
  ## 
  let valid = call_564287.validator(path, query, header, formData, body)
  let scheme = call_564287.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564287.url(scheme.get, call_564287.host, call_564287.base,
                         call_564287.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564287, url, valid)

proc call*(call_564288: Call_VolumesUpdate_564277; subscriptionId: string;
          volumeName: string; poolName: string; resourceGroupName: string;
          body: JsonNode; accountName: string; apiVersion: string = "2017-08-15"): Recallable =
  ## volumesUpdate
  ## Patch a volume
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
  var path_564289 = newJObject()
  var query_564290 = newJObject()
  var body_564291 = newJObject()
  add(query_564290, "api-version", newJString(apiVersion))
  add(path_564289, "subscriptionId", newJString(subscriptionId))
  add(path_564289, "volumeName", newJString(volumeName))
  add(path_564289, "poolName", newJString(poolName))
  add(path_564289, "resourceGroupName", newJString(resourceGroupName))
  if body != nil:
    body_564291 = body
  add(path_564289, "accountName", newJString(accountName))
  result = call_564288.call(path_564289, query_564290, nil, nil, body_564291)

var volumesUpdate* = Call_VolumesUpdate_564277(name: "volumesUpdate",
    meth: HttpMethod.HttpPatch, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.NetApp/netAppAccounts/{accountName}/capacityPools/{poolName}/volumes/{volumeName}",
    validator: validate_VolumesUpdate_564278, base: "", url: url_VolumesUpdate_564279,
    schemes: {Scheme.Https})
type
  Call_VolumesDelete_564264 = ref object of OpenApiRestCall_563556
proc url_VolumesDelete_564266(protocol: Scheme; host: string; base: string;
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

proc validate_VolumesDelete_564265(path: JsonNode; query: JsonNode; header: JsonNode;
                                  formData: JsonNode; body: JsonNode): JsonNode =
  ## Delete a volume
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
  var valid_564267 = path.getOrDefault("subscriptionId")
  valid_564267 = validateParameter(valid_564267, JString, required = true,
                                 default = nil)
  if valid_564267 != nil:
    section.add "subscriptionId", valid_564267
  var valid_564268 = path.getOrDefault("volumeName")
  valid_564268 = validateParameter(valid_564268, JString, required = true,
                                 default = nil)
  if valid_564268 != nil:
    section.add "volumeName", valid_564268
  var valid_564269 = path.getOrDefault("poolName")
  valid_564269 = validateParameter(valid_564269, JString, required = true,
                                 default = nil)
  if valid_564269 != nil:
    section.add "poolName", valid_564269
  var valid_564270 = path.getOrDefault("resourceGroupName")
  valid_564270 = validateParameter(valid_564270, JString, required = true,
                                 default = nil)
  if valid_564270 != nil:
    section.add "resourceGroupName", valid_564270
  var valid_564271 = path.getOrDefault("accountName")
  valid_564271 = validateParameter(valid_564271, JString, required = true,
                                 default = nil)
  if valid_564271 != nil:
    section.add "accountName", valid_564271
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564272 = query.getOrDefault("api-version")
  valid_564272 = validateParameter(valid_564272, JString, required = true,
                                 default = newJString("2017-08-15"))
  if valid_564272 != nil:
    section.add "api-version", valid_564272
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564273: Call_VolumesDelete_564264; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete a volume
  ## 
  let valid = call_564273.validator(path, query, header, formData, body)
  let scheme = call_564273.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564273.url(scheme.get, call_564273.host, call_564273.base,
                         call_564273.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564273, url, valid)

proc call*(call_564274: Call_VolumesDelete_564264; subscriptionId: string;
          volumeName: string; poolName: string; resourceGroupName: string;
          accountName: string; apiVersion: string = "2017-08-15"): Recallable =
  ## volumesDelete
  ## Delete a volume
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
  var path_564275 = newJObject()
  var query_564276 = newJObject()
  add(query_564276, "api-version", newJString(apiVersion))
  add(path_564275, "subscriptionId", newJString(subscriptionId))
  add(path_564275, "volumeName", newJString(volumeName))
  add(path_564275, "poolName", newJString(poolName))
  add(path_564275, "resourceGroupName", newJString(resourceGroupName))
  add(path_564275, "accountName", newJString(accountName))
  result = call_564274.call(path_564275, query_564276, nil, nil, nil)

var volumesDelete* = Call_VolumesDelete_564264(name: "volumesDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.NetApp/netAppAccounts/{accountName}/capacityPools/{poolName}/volumes/{volumeName}",
    validator: validate_VolumesDelete_564265, base: "", url: url_VolumesDelete_564266,
    schemes: {Scheme.Https})
type
  Call_MountTargetsList_564292 = ref object of OpenApiRestCall_563556
proc url_MountTargetsList_564294(protocol: Scheme; host: string; base: string;
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

proc validate_MountTargetsList_564293(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## List mount targets
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
  var valid_564295 = path.getOrDefault("subscriptionId")
  valid_564295 = validateParameter(valid_564295, JString, required = true,
                                 default = nil)
  if valid_564295 != nil:
    section.add "subscriptionId", valid_564295
  var valid_564296 = path.getOrDefault("volumeName")
  valid_564296 = validateParameter(valid_564296, JString, required = true,
                                 default = nil)
  if valid_564296 != nil:
    section.add "volumeName", valid_564296
  var valid_564297 = path.getOrDefault("poolName")
  valid_564297 = validateParameter(valid_564297, JString, required = true,
                                 default = nil)
  if valid_564297 != nil:
    section.add "poolName", valid_564297
  var valid_564298 = path.getOrDefault("resourceGroupName")
  valid_564298 = validateParameter(valid_564298, JString, required = true,
                                 default = nil)
  if valid_564298 != nil:
    section.add "resourceGroupName", valid_564298
  var valid_564299 = path.getOrDefault("accountName")
  valid_564299 = validateParameter(valid_564299, JString, required = true,
                                 default = nil)
  if valid_564299 != nil:
    section.add "accountName", valid_564299
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564300 = query.getOrDefault("api-version")
  valid_564300 = validateParameter(valid_564300, JString, required = true,
                                 default = newJString("2017-08-15"))
  if valid_564300 != nil:
    section.add "api-version", valid_564300
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564301: Call_MountTargetsList_564292; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List mount targets
  ## 
  let valid = call_564301.validator(path, query, header, formData, body)
  let scheme = call_564301.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564301.url(scheme.get, call_564301.host, call_564301.base,
                         call_564301.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564301, url, valid)

proc call*(call_564302: Call_MountTargetsList_564292; subscriptionId: string;
          volumeName: string; poolName: string; resourceGroupName: string;
          accountName: string; apiVersion: string = "2017-08-15"): Recallable =
  ## mountTargetsList
  ## List mount targets
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
  var path_564303 = newJObject()
  var query_564304 = newJObject()
  add(query_564304, "api-version", newJString(apiVersion))
  add(path_564303, "subscriptionId", newJString(subscriptionId))
  add(path_564303, "volumeName", newJString(volumeName))
  add(path_564303, "poolName", newJString(poolName))
  add(path_564303, "resourceGroupName", newJString(resourceGroupName))
  add(path_564303, "accountName", newJString(accountName))
  result = call_564302.call(path_564303, query_564304, nil, nil, nil)

var mountTargetsList* = Call_MountTargetsList_564292(name: "mountTargetsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.NetApp/netAppAccounts/{accountName}/capacityPools/{poolName}/volumes/{volumeName}/mountTargets",
    validator: validate_MountTargetsList_564293, base: "",
    url: url_MountTargetsList_564294, schemes: {Scheme.Https})
type
  Call_SnapshotsList_564305 = ref object of OpenApiRestCall_563556
proc url_SnapshotsList_564307(protocol: Scheme; host: string; base: string;
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

proc validate_SnapshotsList_564306(path: JsonNode; query: JsonNode; header: JsonNode;
                                  formData: JsonNode; body: JsonNode): JsonNode =
  ## List snapshots
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
  var valid_564308 = path.getOrDefault("subscriptionId")
  valid_564308 = validateParameter(valid_564308, JString, required = true,
                                 default = nil)
  if valid_564308 != nil:
    section.add "subscriptionId", valid_564308
  var valid_564309 = path.getOrDefault("volumeName")
  valid_564309 = validateParameter(valid_564309, JString, required = true,
                                 default = nil)
  if valid_564309 != nil:
    section.add "volumeName", valid_564309
  var valid_564310 = path.getOrDefault("poolName")
  valid_564310 = validateParameter(valid_564310, JString, required = true,
                                 default = nil)
  if valid_564310 != nil:
    section.add "poolName", valid_564310
  var valid_564311 = path.getOrDefault("resourceGroupName")
  valid_564311 = validateParameter(valid_564311, JString, required = true,
                                 default = nil)
  if valid_564311 != nil:
    section.add "resourceGroupName", valid_564311
  var valid_564312 = path.getOrDefault("accountName")
  valid_564312 = validateParameter(valid_564312, JString, required = true,
                                 default = nil)
  if valid_564312 != nil:
    section.add "accountName", valid_564312
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564313 = query.getOrDefault("api-version")
  valid_564313 = validateParameter(valid_564313, JString, required = true,
                                 default = newJString("2017-08-15"))
  if valid_564313 != nil:
    section.add "api-version", valid_564313
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564314: Call_SnapshotsList_564305; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List snapshots
  ## 
  let valid = call_564314.validator(path, query, header, formData, body)
  let scheme = call_564314.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564314.url(scheme.get, call_564314.host, call_564314.base,
                         call_564314.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564314, url, valid)

proc call*(call_564315: Call_SnapshotsList_564305; subscriptionId: string;
          volumeName: string; poolName: string; resourceGroupName: string;
          accountName: string; apiVersion: string = "2017-08-15"): Recallable =
  ## snapshotsList
  ## List snapshots
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
  var path_564316 = newJObject()
  var query_564317 = newJObject()
  add(query_564317, "api-version", newJString(apiVersion))
  add(path_564316, "subscriptionId", newJString(subscriptionId))
  add(path_564316, "volumeName", newJString(volumeName))
  add(path_564316, "poolName", newJString(poolName))
  add(path_564316, "resourceGroupName", newJString(resourceGroupName))
  add(path_564316, "accountName", newJString(accountName))
  result = call_564315.call(path_564316, query_564317, nil, nil, nil)

var snapshotsList* = Call_SnapshotsList_564305(name: "snapshotsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.NetApp/netAppAccounts/{accountName}/capacityPools/{poolName}/volumes/{volumeName}/snapshots",
    validator: validate_SnapshotsList_564306, base: "", url: url_SnapshotsList_564307,
    schemes: {Scheme.Https})
type
  Call_SnapshotsCreate_564332 = ref object of OpenApiRestCall_563556
proc url_SnapshotsCreate_564334(protocol: Scheme; host: string; base: string;
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

proc validate_SnapshotsCreate_564333(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Create a snapshot
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
  var valid_564335 = path.getOrDefault("subscriptionId")
  valid_564335 = validateParameter(valid_564335, JString, required = true,
                                 default = nil)
  if valid_564335 != nil:
    section.add "subscriptionId", valid_564335
  var valid_564336 = path.getOrDefault("volumeName")
  valid_564336 = validateParameter(valid_564336, JString, required = true,
                                 default = nil)
  if valid_564336 != nil:
    section.add "volumeName", valid_564336
  var valid_564337 = path.getOrDefault("poolName")
  valid_564337 = validateParameter(valid_564337, JString, required = true,
                                 default = nil)
  if valid_564337 != nil:
    section.add "poolName", valid_564337
  var valid_564338 = path.getOrDefault("resourceGroupName")
  valid_564338 = validateParameter(valid_564338, JString, required = true,
                                 default = nil)
  if valid_564338 != nil:
    section.add "resourceGroupName", valid_564338
  var valid_564339 = path.getOrDefault("snapshotName")
  valid_564339 = validateParameter(valid_564339, JString, required = true,
                                 default = nil)
  if valid_564339 != nil:
    section.add "snapshotName", valid_564339
  var valid_564340 = path.getOrDefault("accountName")
  valid_564340 = validateParameter(valid_564340, JString, required = true,
                                 default = nil)
  if valid_564340 != nil:
    section.add "accountName", valid_564340
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564341 = query.getOrDefault("api-version")
  valid_564341 = validateParameter(valid_564341, JString, required = true,
                                 default = newJString("2017-08-15"))
  if valid_564341 != nil:
    section.add "api-version", valid_564341
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

proc call*(call_564343: Call_SnapshotsCreate_564332; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create a snapshot
  ## 
  let valid = call_564343.validator(path, query, header, formData, body)
  let scheme = call_564343.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564343.url(scheme.get, call_564343.host, call_564343.base,
                         call_564343.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564343, url, valid)

proc call*(call_564344: Call_SnapshotsCreate_564332; subscriptionId: string;
          volumeName: string; poolName: string; resourceGroupName: string;
          snapshotName: string; body: JsonNode; accountName: string;
          apiVersion: string = "2017-08-15"): Recallable =
  ## snapshotsCreate
  ## Create a snapshot
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
  ##   body: JObject (required)
  ##       : Snapshot object supplied in the body of the operation.
  ##   accountName: string (required)
  ##              : The name of the NetApp account
  var path_564345 = newJObject()
  var query_564346 = newJObject()
  var body_564347 = newJObject()
  add(query_564346, "api-version", newJString(apiVersion))
  add(path_564345, "subscriptionId", newJString(subscriptionId))
  add(path_564345, "volumeName", newJString(volumeName))
  add(path_564345, "poolName", newJString(poolName))
  add(path_564345, "resourceGroupName", newJString(resourceGroupName))
  add(path_564345, "snapshotName", newJString(snapshotName))
  if body != nil:
    body_564347 = body
  add(path_564345, "accountName", newJString(accountName))
  result = call_564344.call(path_564345, query_564346, nil, nil, body_564347)

var snapshotsCreate* = Call_SnapshotsCreate_564332(name: "snapshotsCreate",
    meth: HttpMethod.HttpPut, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.NetApp/netAppAccounts/{accountName}/capacityPools/{poolName}/volumes/{volumeName}/snapshots/{snapshotName}",
    validator: validate_SnapshotsCreate_564333, base: "", url: url_SnapshotsCreate_564334,
    schemes: {Scheme.Https})
type
  Call_SnapshotsGet_564318 = ref object of OpenApiRestCall_563556
proc url_SnapshotsGet_564320(protocol: Scheme; host: string; base: string;
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

proc validate_SnapshotsGet_564319(path: JsonNode; query: JsonNode; header: JsonNode;
                                 formData: JsonNode; body: JsonNode): JsonNode =
  ## Get a snapshot
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
  var valid_564321 = path.getOrDefault("subscriptionId")
  valid_564321 = validateParameter(valid_564321, JString, required = true,
                                 default = nil)
  if valid_564321 != nil:
    section.add "subscriptionId", valid_564321
  var valid_564322 = path.getOrDefault("volumeName")
  valid_564322 = validateParameter(valid_564322, JString, required = true,
                                 default = nil)
  if valid_564322 != nil:
    section.add "volumeName", valid_564322
  var valid_564323 = path.getOrDefault("poolName")
  valid_564323 = validateParameter(valid_564323, JString, required = true,
                                 default = nil)
  if valid_564323 != nil:
    section.add "poolName", valid_564323
  var valid_564324 = path.getOrDefault("resourceGroupName")
  valid_564324 = validateParameter(valid_564324, JString, required = true,
                                 default = nil)
  if valid_564324 != nil:
    section.add "resourceGroupName", valid_564324
  var valid_564325 = path.getOrDefault("snapshotName")
  valid_564325 = validateParameter(valid_564325, JString, required = true,
                                 default = nil)
  if valid_564325 != nil:
    section.add "snapshotName", valid_564325
  var valid_564326 = path.getOrDefault("accountName")
  valid_564326 = validateParameter(valid_564326, JString, required = true,
                                 default = nil)
  if valid_564326 != nil:
    section.add "accountName", valid_564326
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564327 = query.getOrDefault("api-version")
  valid_564327 = validateParameter(valid_564327, JString, required = true,
                                 default = newJString("2017-08-15"))
  if valid_564327 != nil:
    section.add "api-version", valid_564327
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564328: Call_SnapshotsGet_564318; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get a snapshot
  ## 
  let valid = call_564328.validator(path, query, header, formData, body)
  let scheme = call_564328.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564328.url(scheme.get, call_564328.host, call_564328.base,
                         call_564328.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564328, url, valid)

proc call*(call_564329: Call_SnapshotsGet_564318; subscriptionId: string;
          volumeName: string; poolName: string; resourceGroupName: string;
          snapshotName: string; accountName: string;
          apiVersion: string = "2017-08-15"): Recallable =
  ## snapshotsGet
  ## Get a snapshot
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
  var path_564330 = newJObject()
  var query_564331 = newJObject()
  add(query_564331, "api-version", newJString(apiVersion))
  add(path_564330, "subscriptionId", newJString(subscriptionId))
  add(path_564330, "volumeName", newJString(volumeName))
  add(path_564330, "poolName", newJString(poolName))
  add(path_564330, "resourceGroupName", newJString(resourceGroupName))
  add(path_564330, "snapshotName", newJString(snapshotName))
  add(path_564330, "accountName", newJString(accountName))
  result = call_564329.call(path_564330, query_564331, nil, nil, nil)

var snapshotsGet* = Call_SnapshotsGet_564318(name: "snapshotsGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.NetApp/netAppAccounts/{accountName}/capacityPools/{poolName}/volumes/{volumeName}/snapshots/{snapshotName}",
    validator: validate_SnapshotsGet_564319, base: "", url: url_SnapshotsGet_564320,
    schemes: {Scheme.Https})
type
  Call_SnapshotsUpdate_564362 = ref object of OpenApiRestCall_563556
proc url_SnapshotsUpdate_564364(protocol: Scheme; host: string; base: string;
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

proc validate_SnapshotsUpdate_564363(path: JsonNode; query: JsonNode;
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
  var valid_564365 = path.getOrDefault("subscriptionId")
  valid_564365 = validateParameter(valid_564365, JString, required = true,
                                 default = nil)
  if valid_564365 != nil:
    section.add "subscriptionId", valid_564365
  var valid_564366 = path.getOrDefault("volumeName")
  valid_564366 = validateParameter(valid_564366, JString, required = true,
                                 default = nil)
  if valid_564366 != nil:
    section.add "volumeName", valid_564366
  var valid_564367 = path.getOrDefault("poolName")
  valid_564367 = validateParameter(valid_564367, JString, required = true,
                                 default = nil)
  if valid_564367 != nil:
    section.add "poolName", valid_564367
  var valid_564368 = path.getOrDefault("resourceGroupName")
  valid_564368 = validateParameter(valid_564368, JString, required = true,
                                 default = nil)
  if valid_564368 != nil:
    section.add "resourceGroupName", valid_564368
  var valid_564369 = path.getOrDefault("snapshotName")
  valid_564369 = validateParameter(valid_564369, JString, required = true,
                                 default = nil)
  if valid_564369 != nil:
    section.add "snapshotName", valid_564369
  var valid_564370 = path.getOrDefault("accountName")
  valid_564370 = validateParameter(valid_564370, JString, required = true,
                                 default = nil)
  if valid_564370 != nil:
    section.add "accountName", valid_564370
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564371 = query.getOrDefault("api-version")
  valid_564371 = validateParameter(valid_564371, JString, required = true,
                                 default = newJString("2017-08-15"))
  if valid_564371 != nil:
    section.add "api-version", valid_564371
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

proc call*(call_564373: Call_SnapshotsUpdate_564362; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Patch a snapshot
  ## 
  let valid = call_564373.validator(path, query, header, formData, body)
  let scheme = call_564373.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564373.url(scheme.get, call_564373.host, call_564373.base,
                         call_564373.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564373, url, valid)

proc call*(call_564374: Call_SnapshotsUpdate_564362; subscriptionId: string;
          volumeName: string; poolName: string; resourceGroupName: string;
          snapshotName: string; body: JsonNode; accountName: string;
          apiVersion: string = "2017-08-15"): Recallable =
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
  ##   snapshotName: string (required)
  ##               : The name of the mount target
  ##   body: JObject (required)
  ##       : Snapshot object supplied in the body of the operation.
  ##   accountName: string (required)
  ##              : The name of the NetApp account
  var path_564375 = newJObject()
  var query_564376 = newJObject()
  var body_564377 = newJObject()
  add(query_564376, "api-version", newJString(apiVersion))
  add(path_564375, "subscriptionId", newJString(subscriptionId))
  add(path_564375, "volumeName", newJString(volumeName))
  add(path_564375, "poolName", newJString(poolName))
  add(path_564375, "resourceGroupName", newJString(resourceGroupName))
  add(path_564375, "snapshotName", newJString(snapshotName))
  if body != nil:
    body_564377 = body
  add(path_564375, "accountName", newJString(accountName))
  result = call_564374.call(path_564375, query_564376, nil, nil, body_564377)

var snapshotsUpdate* = Call_SnapshotsUpdate_564362(name: "snapshotsUpdate",
    meth: HttpMethod.HttpPatch, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.NetApp/netAppAccounts/{accountName}/capacityPools/{poolName}/volumes/{volumeName}/snapshots/{snapshotName}",
    validator: validate_SnapshotsUpdate_564363, base: "", url: url_SnapshotsUpdate_564364,
    schemes: {Scheme.Https})
type
  Call_SnapshotsDelete_564348 = ref object of OpenApiRestCall_563556
proc url_SnapshotsDelete_564350(protocol: Scheme; host: string; base: string;
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

proc validate_SnapshotsDelete_564349(path: JsonNode; query: JsonNode;
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
  var valid_564351 = path.getOrDefault("subscriptionId")
  valid_564351 = validateParameter(valid_564351, JString, required = true,
                                 default = nil)
  if valid_564351 != nil:
    section.add "subscriptionId", valid_564351
  var valid_564352 = path.getOrDefault("volumeName")
  valid_564352 = validateParameter(valid_564352, JString, required = true,
                                 default = nil)
  if valid_564352 != nil:
    section.add "volumeName", valid_564352
  var valid_564353 = path.getOrDefault("poolName")
  valid_564353 = validateParameter(valid_564353, JString, required = true,
                                 default = nil)
  if valid_564353 != nil:
    section.add "poolName", valid_564353
  var valid_564354 = path.getOrDefault("resourceGroupName")
  valid_564354 = validateParameter(valid_564354, JString, required = true,
                                 default = nil)
  if valid_564354 != nil:
    section.add "resourceGroupName", valid_564354
  var valid_564355 = path.getOrDefault("snapshotName")
  valid_564355 = validateParameter(valid_564355, JString, required = true,
                                 default = nil)
  if valid_564355 != nil:
    section.add "snapshotName", valid_564355
  var valid_564356 = path.getOrDefault("accountName")
  valid_564356 = validateParameter(valid_564356, JString, required = true,
                                 default = nil)
  if valid_564356 != nil:
    section.add "accountName", valid_564356
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564357 = query.getOrDefault("api-version")
  valid_564357 = validateParameter(valid_564357, JString, required = true,
                                 default = newJString("2017-08-15"))
  if valid_564357 != nil:
    section.add "api-version", valid_564357
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564358: Call_SnapshotsDelete_564348; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete snapshot
  ## 
  let valid = call_564358.validator(path, query, header, formData, body)
  let scheme = call_564358.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564358.url(scheme.get, call_564358.host, call_564358.base,
                         call_564358.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564358, url, valid)

proc call*(call_564359: Call_SnapshotsDelete_564348; subscriptionId: string;
          volumeName: string; poolName: string; resourceGroupName: string;
          snapshotName: string; accountName: string;
          apiVersion: string = "2017-08-15"): Recallable =
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
  var path_564360 = newJObject()
  var query_564361 = newJObject()
  add(query_564361, "api-version", newJString(apiVersion))
  add(path_564360, "subscriptionId", newJString(subscriptionId))
  add(path_564360, "volumeName", newJString(volumeName))
  add(path_564360, "poolName", newJString(poolName))
  add(path_564360, "resourceGroupName", newJString(resourceGroupName))
  add(path_564360, "snapshotName", newJString(snapshotName))
  add(path_564360, "accountName", newJString(accountName))
  result = call_564359.call(path_564360, query_564361, nil, nil, nil)

var snapshotsDelete* = Call_SnapshotsDelete_564348(name: "snapshotsDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.NetApp/netAppAccounts/{accountName}/capacityPools/{poolName}/volumes/{volumeName}/snapshots/{snapshotName}",
    validator: validate_SnapshotsDelete_564349, base: "", url: url_SnapshotsDelete_564350,
    schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)

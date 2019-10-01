
import
  json, options, hashes, uri, rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: Azure Maps Resource Provider
## version: 2017-01-01-preview
## termsOfService: (not provided)
## license: (not provided)
## 
## Resource Provider
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

  OpenApiRestCall_567642 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_567642](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_567642): Option[Scheme] {.used.} =
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
  macServiceName = "maps-maps-management"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_AccountsListOperations_567864 = ref object of OpenApiRestCall_567642
proc url_AccountsListOperations_567866(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_AccountsListOperations_567865(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List operations available for the Maps Resource Provider
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
  var valid_568025 = query.getOrDefault("api-version")
  valid_568025 = validateParameter(valid_568025, JString, required = true,
                                 default = nil)
  if valid_568025 != nil:
    section.add "api-version", valid_568025
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568048: Call_AccountsListOperations_567864; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List operations available for the Maps Resource Provider
  ## 
  let valid = call_568048.validator(path, query, header, formData, body)
  let scheme = call_568048.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568048.url(scheme.get, call_568048.host, call_568048.base,
                         call_568048.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568048, url, valid)

proc call*(call_568119: Call_AccountsListOperations_567864; apiVersion: string): Recallable =
  ## accountsListOperations
  ## List operations available for the Maps Resource Provider
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  var query_568120 = newJObject()
  add(query_568120, "api-version", newJString(apiVersion))
  result = call_568119.call(nil, query_568120, nil, nil, nil)

var accountsListOperations* = Call_AccountsListOperations_567864(
    name: "accountsListOperations", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Maps/operations",
    validator: validate_AccountsListOperations_567865, base: "",
    url: url_AccountsListOperations_567866, schemes: {Scheme.Https})
type
  Call_AccountsListBySubscription_568160 = ref object of OpenApiRestCall_567642
proc url_AccountsListBySubscription_568162(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Maps/accounts")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AccountsListBySubscription_568161(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get all Maps Accounts in a Subscription
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_568177 = path.getOrDefault("subscriptionId")
  valid_568177 = validateParameter(valid_568177, JString, required = true,
                                 default = nil)
  if valid_568177 != nil:
    section.add "subscriptionId", valid_568177
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568178 = query.getOrDefault("api-version")
  valid_568178 = validateParameter(valid_568178, JString, required = true,
                                 default = nil)
  if valid_568178 != nil:
    section.add "api-version", valid_568178
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568179: Call_AccountsListBySubscription_568160; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get all Maps Accounts in a Subscription
  ## 
  let valid = call_568179.validator(path, query, header, formData, body)
  let scheme = call_568179.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568179.url(scheme.get, call_568179.host, call_568179.base,
                         call_568179.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568179, url, valid)

proc call*(call_568180: Call_AccountsListBySubscription_568160; apiVersion: string;
          subscriptionId: string): Recallable =
  ## accountsListBySubscription
  ## Get all Maps Accounts in a Subscription
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_568181 = newJObject()
  var query_568182 = newJObject()
  add(query_568182, "api-version", newJString(apiVersion))
  add(path_568181, "subscriptionId", newJString(subscriptionId))
  result = call_568180.call(path_568181, query_568182, nil, nil, nil)

var accountsListBySubscription* = Call_AccountsListBySubscription_568160(
    name: "accountsListBySubscription", meth: HttpMethod.HttpGet,
    host: "management.azure.com",
    route: "/subscriptions/{subscriptionId}/providers/Microsoft.Maps/accounts",
    validator: validate_AccountsListBySubscription_568161, base: "",
    url: url_AccountsListBySubscription_568162, schemes: {Scheme.Https})
type
  Call_AccountsMove_568183 = ref object of OpenApiRestCall_567642
proc url_AccountsMove_568185(protocol: Scheme; host: string; base: string;
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
               (kind: VariableSegment, value: "resourceGroupName"),
               (kind: ConstantSegment, value: "/moveResources")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AccountsMove_568184(path: JsonNode; query: JsonNode; header: JsonNode;
                                 formData: JsonNode; body: JsonNode): JsonNode =
  ## Moves Maps Accounts from one ResourceGroup (or Subscription) to another
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains Maps Account to move.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568186 = path.getOrDefault("resourceGroupName")
  valid_568186 = validateParameter(valid_568186, JString, required = true,
                                 default = nil)
  if valid_568186 != nil:
    section.add "resourceGroupName", valid_568186
  var valid_568187 = path.getOrDefault("subscriptionId")
  valid_568187 = validateParameter(valid_568187, JString, required = true,
                                 default = nil)
  if valid_568187 != nil:
    section.add "subscriptionId", valid_568187
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568188 = query.getOrDefault("api-version")
  valid_568188 = validateParameter(valid_568188, JString, required = true,
                                 default = nil)
  if valid_568188 != nil:
    section.add "api-version", valid_568188
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   moveRequest: JObject (required)
  ##              : The details of the Maps Account move.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568190: Call_AccountsMove_568183; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Moves Maps Accounts from one ResourceGroup (or Subscription) to another
  ## 
  let valid = call_568190.validator(path, query, header, formData, body)
  let scheme = call_568190.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568190.url(scheme.get, call_568190.host, call_568190.base,
                         call_568190.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568190, url, valid)

proc call*(call_568191: Call_AccountsMove_568183; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; moveRequest: JsonNode): Recallable =
  ## accountsMove
  ## Moves Maps Accounts from one ResourceGroup (or Subscription) to another
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains Maps Account to move.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   moveRequest: JObject (required)
  ##              : The details of the Maps Account move.
  var path_568192 = newJObject()
  var query_568193 = newJObject()
  var body_568194 = newJObject()
  add(path_568192, "resourceGroupName", newJString(resourceGroupName))
  add(query_568193, "api-version", newJString(apiVersion))
  add(path_568192, "subscriptionId", newJString(subscriptionId))
  if moveRequest != nil:
    body_568194 = moveRequest
  result = call_568191.call(path_568192, query_568193, nil, nil, body_568194)

var accountsMove* = Call_AccountsMove_568183(name: "accountsMove",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/moveResources",
    validator: validate_AccountsMove_568184, base: "", url: url_AccountsMove_568185,
    schemes: {Scheme.Https})
type
  Call_AccountsListByResourceGroup_568195 = ref object of OpenApiRestCall_567642
proc url_AccountsListByResourceGroup_568197(protocol: Scheme; host: string;
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
        kind: ConstantSegment, value: "/providers/Microsoft.Maps/accounts")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AccountsListByResourceGroup_568196(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get all Maps Accounts in a Resource Group
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the Azure Resource Group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568198 = path.getOrDefault("resourceGroupName")
  valid_568198 = validateParameter(valid_568198, JString, required = true,
                                 default = nil)
  if valid_568198 != nil:
    section.add "resourceGroupName", valid_568198
  var valid_568199 = path.getOrDefault("subscriptionId")
  valid_568199 = validateParameter(valid_568199, JString, required = true,
                                 default = nil)
  if valid_568199 != nil:
    section.add "subscriptionId", valid_568199
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568200 = query.getOrDefault("api-version")
  valid_568200 = validateParameter(valid_568200, JString, required = true,
                                 default = nil)
  if valid_568200 != nil:
    section.add "api-version", valid_568200
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568201: Call_AccountsListByResourceGroup_568195; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get all Maps Accounts in a Resource Group
  ## 
  let valid = call_568201.validator(path, query, header, formData, body)
  let scheme = call_568201.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568201.url(scheme.get, call_568201.host, call_568201.base,
                         call_568201.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568201, url, valid)

proc call*(call_568202: Call_AccountsListByResourceGroup_568195;
          resourceGroupName: string; apiVersion: string; subscriptionId: string): Recallable =
  ## accountsListByResourceGroup
  ## Get all Maps Accounts in a Resource Group
  ##   resourceGroupName: string (required)
  ##                    : The name of the Azure Resource Group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_568203 = newJObject()
  var query_568204 = newJObject()
  add(path_568203, "resourceGroupName", newJString(resourceGroupName))
  add(query_568204, "api-version", newJString(apiVersion))
  add(path_568203, "subscriptionId", newJString(subscriptionId))
  result = call_568202.call(path_568203, query_568204, nil, nil, nil)

var accountsListByResourceGroup* = Call_AccountsListByResourceGroup_568195(
    name: "accountsListByResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Maps/accounts",
    validator: validate_AccountsListByResourceGroup_568196, base: "",
    url: url_AccountsListByResourceGroup_568197, schemes: {Scheme.Https})
type
  Call_AccountsCreateOrUpdate_568216 = ref object of OpenApiRestCall_567642
proc url_AccountsCreateOrUpdate_568218(protocol: Scheme; host: string; base: string;
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
        kind: ConstantSegment, value: "/providers/Microsoft.Maps/accounts/"),
               (kind: VariableSegment, value: "accountName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AccountsCreateOrUpdate_568217(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create or update a Maps Account. A Maps Account holds the keys which allow access to the Maps REST APIs.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the Azure Resource Group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   accountName: JString (required)
  ##              : The name of the Maps Account.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568219 = path.getOrDefault("resourceGroupName")
  valid_568219 = validateParameter(valid_568219, JString, required = true,
                                 default = nil)
  if valid_568219 != nil:
    section.add "resourceGroupName", valid_568219
  var valid_568220 = path.getOrDefault("subscriptionId")
  valid_568220 = validateParameter(valid_568220, JString, required = true,
                                 default = nil)
  if valid_568220 != nil:
    section.add "subscriptionId", valid_568220
  var valid_568221 = path.getOrDefault("accountName")
  valid_568221 = validateParameter(valid_568221, JString, required = true,
                                 default = nil)
  if valid_568221 != nil:
    section.add "accountName", valid_568221
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568222 = query.getOrDefault("api-version")
  valid_568222 = validateParameter(valid_568222, JString, required = true,
                                 default = nil)
  if valid_568222 != nil:
    section.add "api-version", valid_568222
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   MapsAccountCreateParameters: JObject (required)
  ##                              : The new or updated parameters for the Maps Account.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568224: Call_AccountsCreateOrUpdate_568216; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create or update a Maps Account. A Maps Account holds the keys which allow access to the Maps REST APIs.
  ## 
  let valid = call_568224.validator(path, query, header, formData, body)
  let scheme = call_568224.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568224.url(scheme.get, call_568224.host, call_568224.base,
                         call_568224.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568224, url, valid)

proc call*(call_568225: Call_AccountsCreateOrUpdate_568216;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          MapsAccountCreateParameters: JsonNode; accountName: string): Recallable =
  ## accountsCreateOrUpdate
  ## Create or update a Maps Account. A Maps Account holds the keys which allow access to the Maps REST APIs.
  ##   resourceGroupName: string (required)
  ##                    : The name of the Azure Resource Group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   MapsAccountCreateParameters: JObject (required)
  ##                              : The new or updated parameters for the Maps Account.
  ##   accountName: string (required)
  ##              : The name of the Maps Account.
  var path_568226 = newJObject()
  var query_568227 = newJObject()
  var body_568228 = newJObject()
  add(path_568226, "resourceGroupName", newJString(resourceGroupName))
  add(query_568227, "api-version", newJString(apiVersion))
  add(path_568226, "subscriptionId", newJString(subscriptionId))
  if MapsAccountCreateParameters != nil:
    body_568228 = MapsAccountCreateParameters
  add(path_568226, "accountName", newJString(accountName))
  result = call_568225.call(path_568226, query_568227, nil, nil, body_568228)

var accountsCreateOrUpdate* = Call_AccountsCreateOrUpdate_568216(
    name: "accountsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Maps/accounts/{accountName}",
    validator: validate_AccountsCreateOrUpdate_568217, base: "",
    url: url_AccountsCreateOrUpdate_568218, schemes: {Scheme.Https})
type
  Call_AccountsGet_568205 = ref object of OpenApiRestCall_567642
proc url_AccountsGet_568207(protocol: Scheme; host: string; base: string;
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
        kind: ConstantSegment, value: "/providers/Microsoft.Maps/accounts/"),
               (kind: VariableSegment, value: "accountName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AccountsGet_568206(path: JsonNode; query: JsonNode; header: JsonNode;
                                formData: JsonNode; body: JsonNode): JsonNode =
  ## Get a Maps Account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the Azure Resource Group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   accountName: JString (required)
  ##              : The name of the Maps Account.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568208 = path.getOrDefault("resourceGroupName")
  valid_568208 = validateParameter(valid_568208, JString, required = true,
                                 default = nil)
  if valid_568208 != nil:
    section.add "resourceGroupName", valid_568208
  var valid_568209 = path.getOrDefault("subscriptionId")
  valid_568209 = validateParameter(valid_568209, JString, required = true,
                                 default = nil)
  if valid_568209 != nil:
    section.add "subscriptionId", valid_568209
  var valid_568210 = path.getOrDefault("accountName")
  valid_568210 = validateParameter(valid_568210, JString, required = true,
                                 default = nil)
  if valid_568210 != nil:
    section.add "accountName", valid_568210
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568211 = query.getOrDefault("api-version")
  valid_568211 = validateParameter(valid_568211, JString, required = true,
                                 default = nil)
  if valid_568211 != nil:
    section.add "api-version", valid_568211
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568212: Call_AccountsGet_568205; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get a Maps Account.
  ## 
  let valid = call_568212.validator(path, query, header, formData, body)
  let scheme = call_568212.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568212.url(scheme.get, call_568212.host, call_568212.base,
                         call_568212.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568212, url, valid)

proc call*(call_568213: Call_AccountsGet_568205; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; accountName: string): Recallable =
  ## accountsGet
  ## Get a Maps Account.
  ##   resourceGroupName: string (required)
  ##                    : The name of the Azure Resource Group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   accountName: string (required)
  ##              : The name of the Maps Account.
  var path_568214 = newJObject()
  var query_568215 = newJObject()
  add(path_568214, "resourceGroupName", newJString(resourceGroupName))
  add(query_568215, "api-version", newJString(apiVersion))
  add(path_568214, "subscriptionId", newJString(subscriptionId))
  add(path_568214, "accountName", newJString(accountName))
  result = call_568213.call(path_568214, query_568215, nil, nil, nil)

var accountsGet* = Call_AccountsGet_568205(name: "accountsGet",
                                        meth: HttpMethod.HttpGet,
                                        host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Maps/accounts/{accountName}",
                                        validator: validate_AccountsGet_568206,
                                        base: "", url: url_AccountsGet_568207,
                                        schemes: {Scheme.Https})
type
  Call_AccountsUpdate_568240 = ref object of OpenApiRestCall_567642
proc url_AccountsUpdate_568242(protocol: Scheme; host: string; base: string;
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
        kind: ConstantSegment, value: "/providers/Microsoft.Maps/accounts/"),
               (kind: VariableSegment, value: "accountName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AccountsUpdate_568241(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Updates a Maps Account. Only a subset of the parameters may be updated after creation, such as Sku and Tags.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the Azure Resource Group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   accountName: JString (required)
  ##              : The name of the Maps Account.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568243 = path.getOrDefault("resourceGroupName")
  valid_568243 = validateParameter(valid_568243, JString, required = true,
                                 default = nil)
  if valid_568243 != nil:
    section.add "resourceGroupName", valid_568243
  var valid_568244 = path.getOrDefault("subscriptionId")
  valid_568244 = validateParameter(valid_568244, JString, required = true,
                                 default = nil)
  if valid_568244 != nil:
    section.add "subscriptionId", valid_568244
  var valid_568245 = path.getOrDefault("accountName")
  valid_568245 = validateParameter(valid_568245, JString, required = true,
                                 default = nil)
  if valid_568245 != nil:
    section.add "accountName", valid_568245
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
  ##   MapsAccountUpdateParameters: JObject (required)
  ##                              : The updated parameters for the Maps Account.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568248: Call_AccountsUpdate_568240; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a Maps Account. Only a subset of the parameters may be updated after creation, such as Sku and Tags.
  ## 
  let valid = call_568248.validator(path, query, header, formData, body)
  let scheme = call_568248.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568248.url(scheme.get, call_568248.host, call_568248.base,
                         call_568248.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568248, url, valid)

proc call*(call_568249: Call_AccountsUpdate_568240; resourceGroupName: string;
          apiVersion: string; subscriptionId: string;
          MapsAccountUpdateParameters: JsonNode; accountName: string): Recallable =
  ## accountsUpdate
  ## Updates a Maps Account. Only a subset of the parameters may be updated after creation, such as Sku and Tags.
  ##   resourceGroupName: string (required)
  ##                    : The name of the Azure Resource Group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   MapsAccountUpdateParameters: JObject (required)
  ##                              : The updated parameters for the Maps Account.
  ##   accountName: string (required)
  ##              : The name of the Maps Account.
  var path_568250 = newJObject()
  var query_568251 = newJObject()
  var body_568252 = newJObject()
  add(path_568250, "resourceGroupName", newJString(resourceGroupName))
  add(query_568251, "api-version", newJString(apiVersion))
  add(path_568250, "subscriptionId", newJString(subscriptionId))
  if MapsAccountUpdateParameters != nil:
    body_568252 = MapsAccountUpdateParameters
  add(path_568250, "accountName", newJString(accountName))
  result = call_568249.call(path_568250, query_568251, nil, nil, body_568252)

var accountsUpdate* = Call_AccountsUpdate_568240(name: "accountsUpdate",
    meth: HttpMethod.HttpPatch, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Maps/accounts/{accountName}",
    validator: validate_AccountsUpdate_568241, base: "", url: url_AccountsUpdate_568242,
    schemes: {Scheme.Https})
type
  Call_AccountsDelete_568229 = ref object of OpenApiRestCall_567642
proc url_AccountsDelete_568231(protocol: Scheme; host: string; base: string;
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
        kind: ConstantSegment, value: "/providers/Microsoft.Maps/accounts/"),
               (kind: VariableSegment, value: "accountName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AccountsDelete_568230(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Delete a Maps Account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the Azure Resource Group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   accountName: JString (required)
  ##              : The name of the Maps Account.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568232 = path.getOrDefault("resourceGroupName")
  valid_568232 = validateParameter(valid_568232, JString, required = true,
                                 default = nil)
  if valid_568232 != nil:
    section.add "resourceGroupName", valid_568232
  var valid_568233 = path.getOrDefault("subscriptionId")
  valid_568233 = validateParameter(valid_568233, JString, required = true,
                                 default = nil)
  if valid_568233 != nil:
    section.add "subscriptionId", valid_568233
  var valid_568234 = path.getOrDefault("accountName")
  valid_568234 = validateParameter(valid_568234, JString, required = true,
                                 default = nil)
  if valid_568234 != nil:
    section.add "accountName", valid_568234
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568235 = query.getOrDefault("api-version")
  valid_568235 = validateParameter(valid_568235, JString, required = true,
                                 default = nil)
  if valid_568235 != nil:
    section.add "api-version", valid_568235
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568236: Call_AccountsDelete_568229; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete a Maps Account.
  ## 
  let valid = call_568236.validator(path, query, header, formData, body)
  let scheme = call_568236.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568236.url(scheme.get, call_568236.host, call_568236.base,
                         call_568236.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568236, url, valid)

proc call*(call_568237: Call_AccountsDelete_568229; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; accountName: string): Recallable =
  ## accountsDelete
  ## Delete a Maps Account.
  ##   resourceGroupName: string (required)
  ##                    : The name of the Azure Resource Group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   accountName: string (required)
  ##              : The name of the Maps Account.
  var path_568238 = newJObject()
  var query_568239 = newJObject()
  add(path_568238, "resourceGroupName", newJString(resourceGroupName))
  add(query_568239, "api-version", newJString(apiVersion))
  add(path_568238, "subscriptionId", newJString(subscriptionId))
  add(path_568238, "accountName", newJString(accountName))
  result = call_568237.call(path_568238, query_568239, nil, nil, nil)

var accountsDelete* = Call_AccountsDelete_568229(name: "accountsDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Maps/accounts/{accountName}",
    validator: validate_AccountsDelete_568230, base: "", url: url_AccountsDelete_568231,
    schemes: {Scheme.Https})
type
  Call_AccountsListKeys_568253 = ref object of OpenApiRestCall_567642
proc url_AccountsListKeys_568255(protocol: Scheme; host: string; base: string;
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
        kind: ConstantSegment, value: "/providers/Microsoft.Maps/accounts/"),
               (kind: VariableSegment, value: "accountName"),
               (kind: ConstantSegment, value: "/listKeys")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AccountsListKeys_568254(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Get the keys to use with the Maps APIs. A key is used to authenticate and authorize access to the Maps REST APIs. Only one key is needed at a time; two are given to provide seamless key regeneration.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the Azure Resource Group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   accountName: JString (required)
  ##              : The name of the Maps Account.
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
  var valid_568258 = path.getOrDefault("accountName")
  valid_568258 = validateParameter(valid_568258, JString, required = true,
                                 default = nil)
  if valid_568258 != nil:
    section.add "accountName", valid_568258
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568259 = query.getOrDefault("api-version")
  valid_568259 = validateParameter(valid_568259, JString, required = true,
                                 default = nil)
  if valid_568259 != nil:
    section.add "api-version", valid_568259
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568260: Call_AccountsListKeys_568253; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get the keys to use with the Maps APIs. A key is used to authenticate and authorize access to the Maps REST APIs. Only one key is needed at a time; two are given to provide seamless key regeneration.
  ## 
  let valid = call_568260.validator(path, query, header, formData, body)
  let scheme = call_568260.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568260.url(scheme.get, call_568260.host, call_568260.base,
                         call_568260.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568260, url, valid)

proc call*(call_568261: Call_AccountsListKeys_568253; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; accountName: string): Recallable =
  ## accountsListKeys
  ## Get the keys to use with the Maps APIs. A key is used to authenticate and authorize access to the Maps REST APIs. Only one key is needed at a time; two are given to provide seamless key regeneration.
  ##   resourceGroupName: string (required)
  ##                    : The name of the Azure Resource Group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   accountName: string (required)
  ##              : The name of the Maps Account.
  var path_568262 = newJObject()
  var query_568263 = newJObject()
  add(path_568262, "resourceGroupName", newJString(resourceGroupName))
  add(query_568263, "api-version", newJString(apiVersion))
  add(path_568262, "subscriptionId", newJString(subscriptionId))
  add(path_568262, "accountName", newJString(accountName))
  result = call_568261.call(path_568262, query_568263, nil, nil, nil)

var accountsListKeys* = Call_AccountsListKeys_568253(name: "accountsListKeys",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Maps/accounts/{accountName}/listKeys",
    validator: validate_AccountsListKeys_568254, base: "",
    url: url_AccountsListKeys_568255, schemes: {Scheme.Https})
type
  Call_AccountsRegenerateKeys_568264 = ref object of OpenApiRestCall_567642
proc url_AccountsRegenerateKeys_568266(protocol: Scheme; host: string; base: string;
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
        kind: ConstantSegment, value: "/providers/Microsoft.Maps/accounts/"),
               (kind: VariableSegment, value: "accountName"),
               (kind: ConstantSegment, value: "/regenerateKey")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AccountsRegenerateKeys_568265(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Regenerate either the primary or secondary key for use with the Maps APIs. The old key will stop working immediately.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the Azure Resource Group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   accountName: JString (required)
  ##              : The name of the Maps Account.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568267 = path.getOrDefault("resourceGroupName")
  valid_568267 = validateParameter(valid_568267, JString, required = true,
                                 default = nil)
  if valid_568267 != nil:
    section.add "resourceGroupName", valid_568267
  var valid_568268 = path.getOrDefault("subscriptionId")
  valid_568268 = validateParameter(valid_568268, JString, required = true,
                                 default = nil)
  if valid_568268 != nil:
    section.add "subscriptionId", valid_568268
  var valid_568269 = path.getOrDefault("accountName")
  valid_568269 = validateParameter(valid_568269, JString, required = true,
                                 default = nil)
  if valid_568269 != nil:
    section.add "accountName", valid_568269
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568270 = query.getOrDefault("api-version")
  valid_568270 = validateParameter(valid_568270, JString, required = true,
                                 default = nil)
  if valid_568270 != nil:
    section.add "api-version", valid_568270
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   keySpecification: JObject (required)
  ##                   : Which key to regenerate:  primary or secondary.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568272: Call_AccountsRegenerateKeys_568264; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Regenerate either the primary or secondary key for use with the Maps APIs. The old key will stop working immediately.
  ## 
  let valid = call_568272.validator(path, query, header, formData, body)
  let scheme = call_568272.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568272.url(scheme.get, call_568272.host, call_568272.base,
                         call_568272.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568272, url, valid)

proc call*(call_568273: Call_AccountsRegenerateKeys_568264;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          keySpecification: JsonNode; accountName: string): Recallable =
  ## accountsRegenerateKeys
  ## Regenerate either the primary or secondary key for use with the Maps APIs. The old key will stop working immediately.
  ##   resourceGroupName: string (required)
  ##                    : The name of the Azure Resource Group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   keySpecification: JObject (required)
  ##                   : Which key to regenerate:  primary or secondary.
  ##   accountName: string (required)
  ##              : The name of the Maps Account.
  var path_568274 = newJObject()
  var query_568275 = newJObject()
  var body_568276 = newJObject()
  add(path_568274, "resourceGroupName", newJString(resourceGroupName))
  add(query_568275, "api-version", newJString(apiVersion))
  add(path_568274, "subscriptionId", newJString(subscriptionId))
  if keySpecification != nil:
    body_568276 = keySpecification
  add(path_568274, "accountName", newJString(accountName))
  result = call_568273.call(path_568274, query_568275, nil, nil, body_568276)

var accountsRegenerateKeys* = Call_AccountsRegenerateKeys_568264(
    name: "accountsRegenerateKeys", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Maps/accounts/{accountName}/regenerateKey",
    validator: validate_AccountsRegenerateKeys_568265, base: "",
    url: url_AccountsRegenerateKeys_568266, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)

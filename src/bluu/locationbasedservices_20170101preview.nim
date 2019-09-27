
import
  json, options, hashes, uri, openapi/rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: Azure Location Based Services Resource Provider
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

  OpenApiRestCall_593408 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_593408](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_593408): Option[Scheme] {.used.} =
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
proc queryString(query: JsonNode): string =
  var qs: seq[KeyVal]
  if query == nil:
    return ""
  for k, v in query.pairs:
    qs.add (key: k, val: v.getStr)
  result = encodeQuery(qs)

proc hydratePath(input: JsonNode; segments: seq[PathToken]): Option[string] =
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
  macServiceName = "locationbasedservices"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_AccountsListOperations_593630 = ref object of OpenApiRestCall_593408
proc url_AccountsListOperations_593632(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_AccountsListOperations_593631(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List operations available for the Location Based Services Resource Provider
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
  var valid_593791 = query.getOrDefault("api-version")
  valid_593791 = validateParameter(valid_593791, JString, required = true,
                                 default = nil)
  if valid_593791 != nil:
    section.add "api-version", valid_593791
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593814: Call_AccountsListOperations_593630; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List operations available for the Location Based Services Resource Provider
  ## 
  let valid = call_593814.validator(path, query, header, formData, body)
  let scheme = call_593814.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593814.url(scheme.get, call_593814.host, call_593814.base,
                         call_593814.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593814, url, valid)

proc call*(call_593885: Call_AccountsListOperations_593630; apiVersion: string): Recallable =
  ## accountsListOperations
  ## List operations available for the Location Based Services Resource Provider
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  var query_593886 = newJObject()
  add(query_593886, "api-version", newJString(apiVersion))
  result = call_593885.call(nil, query_593886, nil, nil, nil)

var accountsListOperations* = Call_AccountsListOperations_593630(
    name: "accountsListOperations", meth: HttpMethod.HttpGet,
    host: "management.azure.com",
    route: "/providers/Microsoft.LocationBasedServices/operations",
    validator: validate_AccountsListOperations_593631, base: "",
    url: url_AccountsListOperations_593632, schemes: {Scheme.Https})
type
  Call_AccountsListBySubscription_593926 = ref object of OpenApiRestCall_593408
proc url_AccountsListBySubscription_593928(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.LocationBasedServices/accounts")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AccountsListBySubscription_593927(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get all Location Based Services Accounts in a Subscription
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_593943 = path.getOrDefault("subscriptionId")
  valid_593943 = validateParameter(valid_593943, JString, required = true,
                                 default = nil)
  if valid_593943 != nil:
    section.add "subscriptionId", valid_593943
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593944 = query.getOrDefault("api-version")
  valid_593944 = validateParameter(valid_593944, JString, required = true,
                                 default = nil)
  if valid_593944 != nil:
    section.add "api-version", valid_593944
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593945: Call_AccountsListBySubscription_593926; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get all Location Based Services Accounts in a Subscription
  ## 
  let valid = call_593945.validator(path, query, header, formData, body)
  let scheme = call_593945.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593945.url(scheme.get, call_593945.host, call_593945.base,
                         call_593945.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593945, url, valid)

proc call*(call_593946: Call_AccountsListBySubscription_593926; apiVersion: string;
          subscriptionId: string): Recallable =
  ## accountsListBySubscription
  ## Get all Location Based Services Accounts in a Subscription
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_593947 = newJObject()
  var query_593948 = newJObject()
  add(query_593948, "api-version", newJString(apiVersion))
  add(path_593947, "subscriptionId", newJString(subscriptionId))
  result = call_593946.call(path_593947, query_593948, nil, nil, nil)

var accountsListBySubscription* = Call_AccountsListBySubscription_593926(
    name: "accountsListBySubscription", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.LocationBasedServices/accounts",
    validator: validate_AccountsListBySubscription_593927, base: "",
    url: url_AccountsListBySubscription_593928, schemes: {Scheme.Https})
type
  Call_AccountsMove_593949 = ref object of OpenApiRestCall_593408
proc url_AccountsMove_593951(protocol: Scheme; host: string; base: string;
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

proc validate_AccountsMove_593950(path: JsonNode; query: JsonNode; header: JsonNode;
                                 formData: JsonNode; body: JsonNode): JsonNode =
  ## Moves Location Based Services Accounts from one ResourceGroup (or Subscription) to another
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains Location Based Services Account to move.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_593952 = path.getOrDefault("resourceGroupName")
  valid_593952 = validateParameter(valid_593952, JString, required = true,
                                 default = nil)
  if valid_593952 != nil:
    section.add "resourceGroupName", valid_593952
  var valid_593953 = path.getOrDefault("subscriptionId")
  valid_593953 = validateParameter(valid_593953, JString, required = true,
                                 default = nil)
  if valid_593953 != nil:
    section.add "subscriptionId", valid_593953
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593954 = query.getOrDefault("api-version")
  valid_593954 = validateParameter(valid_593954, JString, required = true,
                                 default = nil)
  if valid_593954 != nil:
    section.add "api-version", valid_593954
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   moveRequest: JObject (required)
  ##              : The details of the Location Based Services Account move.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_593956: Call_AccountsMove_593949; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Moves Location Based Services Accounts from one ResourceGroup (or Subscription) to another
  ## 
  let valid = call_593956.validator(path, query, header, formData, body)
  let scheme = call_593956.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593956.url(scheme.get, call_593956.host, call_593956.base,
                         call_593956.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593956, url, valid)

proc call*(call_593957: Call_AccountsMove_593949; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; moveRequest: JsonNode): Recallable =
  ## accountsMove
  ## Moves Location Based Services Accounts from one ResourceGroup (or Subscription) to another
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains Location Based Services Account to move.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   moveRequest: JObject (required)
  ##              : The details of the Location Based Services Account move.
  var path_593958 = newJObject()
  var query_593959 = newJObject()
  var body_593960 = newJObject()
  add(path_593958, "resourceGroupName", newJString(resourceGroupName))
  add(query_593959, "api-version", newJString(apiVersion))
  add(path_593958, "subscriptionId", newJString(subscriptionId))
  if moveRequest != nil:
    body_593960 = moveRequest
  result = call_593957.call(path_593958, query_593959, nil, nil, body_593960)

var accountsMove* = Call_AccountsMove_593949(name: "accountsMove",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/moveResources",
    validator: validate_AccountsMove_593950, base: "", url: url_AccountsMove_593951,
    schemes: {Scheme.Https})
type
  Call_AccountsListByResourceGroup_593961 = ref object of OpenApiRestCall_593408
proc url_AccountsListByResourceGroup_593963(protocol: Scheme; host: string;
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
        value: "/providers/Microsoft.LocationBasedServices/accounts")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AccountsListByResourceGroup_593962(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get all Location Based Services Accounts in a Resource Group
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
  var valid_593964 = path.getOrDefault("resourceGroupName")
  valid_593964 = validateParameter(valid_593964, JString, required = true,
                                 default = nil)
  if valid_593964 != nil:
    section.add "resourceGroupName", valid_593964
  var valid_593965 = path.getOrDefault("subscriptionId")
  valid_593965 = validateParameter(valid_593965, JString, required = true,
                                 default = nil)
  if valid_593965 != nil:
    section.add "subscriptionId", valid_593965
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593966 = query.getOrDefault("api-version")
  valid_593966 = validateParameter(valid_593966, JString, required = true,
                                 default = nil)
  if valid_593966 != nil:
    section.add "api-version", valid_593966
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593967: Call_AccountsListByResourceGroup_593961; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get all Location Based Services Accounts in a Resource Group
  ## 
  let valid = call_593967.validator(path, query, header, formData, body)
  let scheme = call_593967.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593967.url(scheme.get, call_593967.host, call_593967.base,
                         call_593967.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593967, url, valid)

proc call*(call_593968: Call_AccountsListByResourceGroup_593961;
          resourceGroupName: string; apiVersion: string; subscriptionId: string): Recallable =
  ## accountsListByResourceGroup
  ## Get all Location Based Services Accounts in a Resource Group
  ##   resourceGroupName: string (required)
  ##                    : The name of the Azure Resource Group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_593969 = newJObject()
  var query_593970 = newJObject()
  add(path_593969, "resourceGroupName", newJString(resourceGroupName))
  add(query_593970, "api-version", newJString(apiVersion))
  add(path_593969, "subscriptionId", newJString(subscriptionId))
  result = call_593968.call(path_593969, query_593970, nil, nil, nil)

var accountsListByResourceGroup* = Call_AccountsListByResourceGroup_593961(
    name: "accountsListByResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.LocationBasedServices/accounts",
    validator: validate_AccountsListByResourceGroup_593962, base: "",
    url: url_AccountsListByResourceGroup_593963, schemes: {Scheme.Https})
type
  Call_AccountsCreateOrUpdate_593982 = ref object of OpenApiRestCall_593408
proc url_AccountsCreateOrUpdate_593984(protocol: Scheme; host: string; base: string;
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
        value: "/providers/Microsoft.LocationBasedServices/accounts/"),
               (kind: VariableSegment, value: "accountName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AccountsCreateOrUpdate_593983(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create or update a Location Based Services Account. A Location Based Services Account holds the keys which allow access to the Location Based Services REST APIs.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the Azure Resource Group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   accountName: JString (required)
  ##              : The name of the Location Based Services Account.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_593985 = path.getOrDefault("resourceGroupName")
  valid_593985 = validateParameter(valid_593985, JString, required = true,
                                 default = nil)
  if valid_593985 != nil:
    section.add "resourceGroupName", valid_593985
  var valid_593986 = path.getOrDefault("subscriptionId")
  valid_593986 = validateParameter(valid_593986, JString, required = true,
                                 default = nil)
  if valid_593986 != nil:
    section.add "subscriptionId", valid_593986
  var valid_593987 = path.getOrDefault("accountName")
  valid_593987 = validateParameter(valid_593987, JString, required = true,
                                 default = nil)
  if valid_593987 != nil:
    section.add "accountName", valid_593987
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593988 = query.getOrDefault("api-version")
  valid_593988 = validateParameter(valid_593988, JString, required = true,
                                 default = nil)
  if valid_593988 != nil:
    section.add "api-version", valid_593988
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   LocationBasedServicesAccountCreateParameters: JObject (required)
  ##                                               : The new or updated parameters for the Location Based Services Account.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_593990: Call_AccountsCreateOrUpdate_593982; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create or update a Location Based Services Account. A Location Based Services Account holds the keys which allow access to the Location Based Services REST APIs.
  ## 
  let valid = call_593990.validator(path, query, header, formData, body)
  let scheme = call_593990.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593990.url(scheme.get, call_593990.host, call_593990.base,
                         call_593990.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593990, url, valid)

proc call*(call_593991: Call_AccountsCreateOrUpdate_593982;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          accountName: string;
          LocationBasedServicesAccountCreateParameters: JsonNode): Recallable =
  ## accountsCreateOrUpdate
  ## Create or update a Location Based Services Account. A Location Based Services Account holds the keys which allow access to the Location Based Services REST APIs.
  ##   resourceGroupName: string (required)
  ##                    : The name of the Azure Resource Group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   accountName: string (required)
  ##              : The name of the Location Based Services Account.
  ##   LocationBasedServicesAccountCreateParameters: JObject (required)
  ##                                               : The new or updated parameters for the Location Based Services Account.
  var path_593992 = newJObject()
  var query_593993 = newJObject()
  var body_593994 = newJObject()
  add(path_593992, "resourceGroupName", newJString(resourceGroupName))
  add(query_593993, "api-version", newJString(apiVersion))
  add(path_593992, "subscriptionId", newJString(subscriptionId))
  add(path_593992, "accountName", newJString(accountName))
  if LocationBasedServicesAccountCreateParameters != nil:
    body_593994 = LocationBasedServicesAccountCreateParameters
  result = call_593991.call(path_593992, query_593993, nil, nil, body_593994)

var accountsCreateOrUpdate* = Call_AccountsCreateOrUpdate_593982(
    name: "accountsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.LocationBasedServices/accounts/{accountName}",
    validator: validate_AccountsCreateOrUpdate_593983, base: "",
    url: url_AccountsCreateOrUpdate_593984, schemes: {Scheme.Https})
type
  Call_AccountsGet_593971 = ref object of OpenApiRestCall_593408
proc url_AccountsGet_593973(protocol: Scheme; host: string; base: string;
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
        value: "/providers/Microsoft.LocationBasedServices/accounts/"),
               (kind: VariableSegment, value: "accountName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AccountsGet_593972(path: JsonNode; query: JsonNode; header: JsonNode;
                                formData: JsonNode; body: JsonNode): JsonNode =
  ## Get a Location Based Services Account
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the Azure Resource Group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   accountName: JString (required)
  ##              : The name of the Location Based Services Account.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_593974 = path.getOrDefault("resourceGroupName")
  valid_593974 = validateParameter(valid_593974, JString, required = true,
                                 default = nil)
  if valid_593974 != nil:
    section.add "resourceGroupName", valid_593974
  var valid_593975 = path.getOrDefault("subscriptionId")
  valid_593975 = validateParameter(valid_593975, JString, required = true,
                                 default = nil)
  if valid_593975 != nil:
    section.add "subscriptionId", valid_593975
  var valid_593976 = path.getOrDefault("accountName")
  valid_593976 = validateParameter(valid_593976, JString, required = true,
                                 default = nil)
  if valid_593976 != nil:
    section.add "accountName", valid_593976
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593977 = query.getOrDefault("api-version")
  valid_593977 = validateParameter(valid_593977, JString, required = true,
                                 default = nil)
  if valid_593977 != nil:
    section.add "api-version", valid_593977
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593978: Call_AccountsGet_593971; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get a Location Based Services Account
  ## 
  let valid = call_593978.validator(path, query, header, formData, body)
  let scheme = call_593978.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593978.url(scheme.get, call_593978.host, call_593978.base,
                         call_593978.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593978, url, valid)

proc call*(call_593979: Call_AccountsGet_593971; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; accountName: string): Recallable =
  ## accountsGet
  ## Get a Location Based Services Account
  ##   resourceGroupName: string (required)
  ##                    : The name of the Azure Resource Group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   accountName: string (required)
  ##              : The name of the Location Based Services Account.
  var path_593980 = newJObject()
  var query_593981 = newJObject()
  add(path_593980, "resourceGroupName", newJString(resourceGroupName))
  add(query_593981, "api-version", newJString(apiVersion))
  add(path_593980, "subscriptionId", newJString(subscriptionId))
  add(path_593980, "accountName", newJString(accountName))
  result = call_593979.call(path_593980, query_593981, nil, nil, nil)

var accountsGet* = Call_AccountsGet_593971(name: "accountsGet",
                                        meth: HttpMethod.HttpGet,
                                        host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.LocationBasedServices/accounts/{accountName}",
                                        validator: validate_AccountsGet_593972,
                                        base: "", url: url_AccountsGet_593973,
                                        schemes: {Scheme.Https})
type
  Call_AccountsUpdate_594006 = ref object of OpenApiRestCall_593408
proc url_AccountsUpdate_594008(protocol: Scheme; host: string; base: string;
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
        value: "/providers/Microsoft.LocationBasedServices/accounts/"),
               (kind: VariableSegment, value: "accountName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AccountsUpdate_594007(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Updates a Location Based Services Account. Only a subset of the parameters may be updated after creation, such as Sku and Tags.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the Azure Resource Group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   accountName: JString (required)
  ##              : The name of the Location Based Services Account.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594009 = path.getOrDefault("resourceGroupName")
  valid_594009 = validateParameter(valid_594009, JString, required = true,
                                 default = nil)
  if valid_594009 != nil:
    section.add "resourceGroupName", valid_594009
  var valid_594010 = path.getOrDefault("subscriptionId")
  valid_594010 = validateParameter(valid_594010, JString, required = true,
                                 default = nil)
  if valid_594010 != nil:
    section.add "subscriptionId", valid_594010
  var valid_594011 = path.getOrDefault("accountName")
  valid_594011 = validateParameter(valid_594011, JString, required = true,
                                 default = nil)
  if valid_594011 != nil:
    section.add "accountName", valid_594011
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594012 = query.getOrDefault("api-version")
  valid_594012 = validateParameter(valid_594012, JString, required = true,
                                 default = nil)
  if valid_594012 != nil:
    section.add "api-version", valid_594012
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   LocationBasedServicesAccountUpdateParameters: JObject (required)
  ##                                               : The updated parameters for the Location Based Services Account.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594014: Call_AccountsUpdate_594006; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a Location Based Services Account. Only a subset of the parameters may be updated after creation, such as Sku and Tags.
  ## 
  let valid = call_594014.validator(path, query, header, formData, body)
  let scheme = call_594014.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594014.url(scheme.get, call_594014.host, call_594014.base,
                         call_594014.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594014, url, valid)

proc call*(call_594015: Call_AccountsUpdate_594006; resourceGroupName: string;
          apiVersion: string; subscriptionId: string;
          LocationBasedServicesAccountUpdateParameters: JsonNode;
          accountName: string): Recallable =
  ## accountsUpdate
  ## Updates a Location Based Services Account. Only a subset of the parameters may be updated after creation, such as Sku and Tags.
  ##   resourceGroupName: string (required)
  ##                    : The name of the Azure Resource Group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   LocationBasedServicesAccountUpdateParameters: JObject (required)
  ##                                               : The updated parameters for the Location Based Services Account.
  ##   accountName: string (required)
  ##              : The name of the Location Based Services Account.
  var path_594016 = newJObject()
  var query_594017 = newJObject()
  var body_594018 = newJObject()
  add(path_594016, "resourceGroupName", newJString(resourceGroupName))
  add(query_594017, "api-version", newJString(apiVersion))
  add(path_594016, "subscriptionId", newJString(subscriptionId))
  if LocationBasedServicesAccountUpdateParameters != nil:
    body_594018 = LocationBasedServicesAccountUpdateParameters
  add(path_594016, "accountName", newJString(accountName))
  result = call_594015.call(path_594016, query_594017, nil, nil, body_594018)

var accountsUpdate* = Call_AccountsUpdate_594006(name: "accountsUpdate",
    meth: HttpMethod.HttpPatch, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.LocationBasedServices/accounts/{accountName}",
    validator: validate_AccountsUpdate_594007, base: "", url: url_AccountsUpdate_594008,
    schemes: {Scheme.Https})
type
  Call_AccountsDelete_593995 = ref object of OpenApiRestCall_593408
proc url_AccountsDelete_593997(protocol: Scheme; host: string; base: string;
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
        value: "/providers/Microsoft.LocationBasedServices/accounts/"),
               (kind: VariableSegment, value: "accountName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AccountsDelete_593996(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Delete a Location Based Services Account
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the Azure Resource Group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   accountName: JString (required)
  ##              : The name of the Location Based Services Account.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_593998 = path.getOrDefault("resourceGroupName")
  valid_593998 = validateParameter(valid_593998, JString, required = true,
                                 default = nil)
  if valid_593998 != nil:
    section.add "resourceGroupName", valid_593998
  var valid_593999 = path.getOrDefault("subscriptionId")
  valid_593999 = validateParameter(valid_593999, JString, required = true,
                                 default = nil)
  if valid_593999 != nil:
    section.add "subscriptionId", valid_593999
  var valid_594000 = path.getOrDefault("accountName")
  valid_594000 = validateParameter(valid_594000, JString, required = true,
                                 default = nil)
  if valid_594000 != nil:
    section.add "accountName", valid_594000
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594001 = query.getOrDefault("api-version")
  valid_594001 = validateParameter(valid_594001, JString, required = true,
                                 default = nil)
  if valid_594001 != nil:
    section.add "api-version", valid_594001
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594002: Call_AccountsDelete_593995; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete a Location Based Services Account
  ## 
  let valid = call_594002.validator(path, query, header, formData, body)
  let scheme = call_594002.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594002.url(scheme.get, call_594002.host, call_594002.base,
                         call_594002.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594002, url, valid)

proc call*(call_594003: Call_AccountsDelete_593995; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; accountName: string): Recallable =
  ## accountsDelete
  ## Delete a Location Based Services Account
  ##   resourceGroupName: string (required)
  ##                    : The name of the Azure Resource Group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   accountName: string (required)
  ##              : The name of the Location Based Services Account.
  var path_594004 = newJObject()
  var query_594005 = newJObject()
  add(path_594004, "resourceGroupName", newJString(resourceGroupName))
  add(query_594005, "api-version", newJString(apiVersion))
  add(path_594004, "subscriptionId", newJString(subscriptionId))
  add(path_594004, "accountName", newJString(accountName))
  result = call_594003.call(path_594004, query_594005, nil, nil, nil)

var accountsDelete* = Call_AccountsDelete_593995(name: "accountsDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.LocationBasedServices/accounts/{accountName}",
    validator: validate_AccountsDelete_593996, base: "", url: url_AccountsDelete_593997,
    schemes: {Scheme.Https})
type
  Call_AccountsListKeys_594019 = ref object of OpenApiRestCall_593408
proc url_AccountsListKeys_594021(protocol: Scheme; host: string; base: string;
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
        value: "/providers/Microsoft.LocationBasedServices/accounts/"),
               (kind: VariableSegment, value: "accountName"),
               (kind: ConstantSegment, value: "/listKeys")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AccountsListKeys_594020(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Get the keys to use with the Location Based Services APIs. A key is used to authenticate and authorize access to the Location Based Services REST APIs. Only one key is needed at a time; two are given to provide seamless key regeneration.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the Azure Resource Group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   accountName: JString (required)
  ##              : The name of the Location Based Services Account.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594022 = path.getOrDefault("resourceGroupName")
  valid_594022 = validateParameter(valid_594022, JString, required = true,
                                 default = nil)
  if valid_594022 != nil:
    section.add "resourceGroupName", valid_594022
  var valid_594023 = path.getOrDefault("subscriptionId")
  valid_594023 = validateParameter(valid_594023, JString, required = true,
                                 default = nil)
  if valid_594023 != nil:
    section.add "subscriptionId", valid_594023
  var valid_594024 = path.getOrDefault("accountName")
  valid_594024 = validateParameter(valid_594024, JString, required = true,
                                 default = nil)
  if valid_594024 != nil:
    section.add "accountName", valid_594024
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594025 = query.getOrDefault("api-version")
  valid_594025 = validateParameter(valid_594025, JString, required = true,
                                 default = nil)
  if valid_594025 != nil:
    section.add "api-version", valid_594025
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594026: Call_AccountsListKeys_594019; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get the keys to use with the Location Based Services APIs. A key is used to authenticate and authorize access to the Location Based Services REST APIs. Only one key is needed at a time; two are given to provide seamless key regeneration.
  ## 
  let valid = call_594026.validator(path, query, header, formData, body)
  let scheme = call_594026.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594026.url(scheme.get, call_594026.host, call_594026.base,
                         call_594026.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594026, url, valid)

proc call*(call_594027: Call_AccountsListKeys_594019; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; accountName: string): Recallable =
  ## accountsListKeys
  ## Get the keys to use with the Location Based Services APIs. A key is used to authenticate and authorize access to the Location Based Services REST APIs. Only one key is needed at a time; two are given to provide seamless key regeneration.
  ##   resourceGroupName: string (required)
  ##                    : The name of the Azure Resource Group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   accountName: string (required)
  ##              : The name of the Location Based Services Account.
  var path_594028 = newJObject()
  var query_594029 = newJObject()
  add(path_594028, "resourceGroupName", newJString(resourceGroupName))
  add(query_594029, "api-version", newJString(apiVersion))
  add(path_594028, "subscriptionId", newJString(subscriptionId))
  add(path_594028, "accountName", newJString(accountName))
  result = call_594027.call(path_594028, query_594029, nil, nil, nil)

var accountsListKeys* = Call_AccountsListKeys_594019(name: "accountsListKeys",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.LocationBasedServices/accounts/{accountName}/listKeys",
    validator: validate_AccountsListKeys_594020, base: "",
    url: url_AccountsListKeys_594021, schemes: {Scheme.Https})
type
  Call_AccountsRegenerateKeys_594030 = ref object of OpenApiRestCall_593408
proc url_AccountsRegenerateKeys_594032(protocol: Scheme; host: string; base: string;
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
        value: "/providers/Microsoft.LocationBasedServices/accounts/"),
               (kind: VariableSegment, value: "accountName"),
               (kind: ConstantSegment, value: "/regenerateKey")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AccountsRegenerateKeys_594031(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Regenerate either the primary or secondary key for use with the Location Based Services APIs. The old key will stop working immediately.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the Azure Resource Group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   accountName: JString (required)
  ##              : The name of the Location Based Services Account.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594033 = path.getOrDefault("resourceGroupName")
  valid_594033 = validateParameter(valid_594033, JString, required = true,
                                 default = nil)
  if valid_594033 != nil:
    section.add "resourceGroupName", valid_594033
  var valid_594034 = path.getOrDefault("subscriptionId")
  valid_594034 = validateParameter(valid_594034, JString, required = true,
                                 default = nil)
  if valid_594034 != nil:
    section.add "subscriptionId", valid_594034
  var valid_594035 = path.getOrDefault("accountName")
  valid_594035 = validateParameter(valid_594035, JString, required = true,
                                 default = nil)
  if valid_594035 != nil:
    section.add "accountName", valid_594035
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594036 = query.getOrDefault("api-version")
  valid_594036 = validateParameter(valid_594036, JString, required = true,
                                 default = nil)
  if valid_594036 != nil:
    section.add "api-version", valid_594036
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

proc call*(call_594038: Call_AccountsRegenerateKeys_594030; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Regenerate either the primary or secondary key for use with the Location Based Services APIs. The old key will stop working immediately.
  ## 
  let valid = call_594038.validator(path, query, header, formData, body)
  let scheme = call_594038.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594038.url(scheme.get, call_594038.host, call_594038.base,
                         call_594038.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594038, url, valid)

proc call*(call_594039: Call_AccountsRegenerateKeys_594030;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          keySpecification: JsonNode; accountName: string): Recallable =
  ## accountsRegenerateKeys
  ## Regenerate either the primary or secondary key for use with the Location Based Services APIs. The old key will stop working immediately.
  ##   resourceGroupName: string (required)
  ##                    : The name of the Azure Resource Group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   keySpecification: JObject (required)
  ##                   : Which key to regenerate:  primary or secondary.
  ##   accountName: string (required)
  ##              : The name of the Location Based Services Account.
  var path_594040 = newJObject()
  var query_594041 = newJObject()
  var body_594042 = newJObject()
  add(path_594040, "resourceGroupName", newJString(resourceGroupName))
  add(query_594041, "api-version", newJString(apiVersion))
  add(path_594040, "subscriptionId", newJString(subscriptionId))
  if keySpecification != nil:
    body_594042 = keySpecification
  add(path_594040, "accountName", newJString(accountName))
  result = call_594039.call(path_594040, query_594041, nil, nil, body_594042)

var accountsRegenerateKeys* = Call_AccountsRegenerateKeys_594030(
    name: "accountsRegenerateKeys", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.LocationBasedServices/accounts/{accountName}/regenerateKey",
    validator: validate_AccountsRegenerateKeys_594031, base: "",
    url: url_AccountsRegenerateKeys_594032, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)


import
  json, options, hashes, uri, rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: KeyVaultManagementClient
## version: 2018-02-14-preview
## termsOfService: (not provided)
## license: (not provided)
## 
## The Azure management API provides a RESTful set of web services that interact with Azure Key Vault.
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

  OpenApiRestCall_567657 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_567657](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_567657): Option[Scheme] {.used.} =
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
  macServiceName = "keyvault"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_VaultsCheckNameAvailability_567879 = ref object of OpenApiRestCall_567657
proc url_VaultsCheckNameAvailability_567881(protocol: Scheme; host: string;
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
        value: "/providers/Microsoft.KeyVault/checkNameAvailability")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VaultsCheckNameAvailability_567880(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Checks that the vault name is valid and is not already in use.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_568071 = path.getOrDefault("subscriptionId")
  valid_568071 = validateParameter(valid_568071, JString, required = true,
                                 default = nil)
  if valid_568071 != nil:
    section.add "subscriptionId", valid_568071
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568072 = query.getOrDefault("api-version")
  valid_568072 = validateParameter(valid_568072, JString, required = true,
                                 default = nil)
  if valid_568072 != nil:
    section.add "api-version", valid_568072
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   vaultName: JObject (required)
  ##            : The name of the vault.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568096: Call_VaultsCheckNameAvailability_567879; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Checks that the vault name is valid and is not already in use.
  ## 
  let valid = call_568096.validator(path, query, header, formData, body)
  let scheme = call_568096.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568096.url(scheme.get, call_568096.host, call_568096.base,
                         call_568096.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568096, url, valid)

proc call*(call_568167: Call_VaultsCheckNameAvailability_567879;
          apiVersion: string; subscriptionId: string; vaultName: JsonNode): Recallable =
  ## vaultsCheckNameAvailability
  ## Checks that the vault name is valid and is not already in use.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   vaultName: JObject (required)
  ##            : The name of the vault.
  var path_568168 = newJObject()
  var query_568170 = newJObject()
  var body_568171 = newJObject()
  add(query_568170, "api-version", newJString(apiVersion))
  add(path_568168, "subscriptionId", newJString(subscriptionId))
  if vaultName != nil:
    body_568171 = vaultName
  result = call_568167.call(path_568168, query_568170, nil, nil, body_568171)

var vaultsCheckNameAvailability* = Call_VaultsCheckNameAvailability_567879(
    name: "vaultsCheckNameAvailability", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.KeyVault/checkNameAvailability",
    validator: validate_VaultsCheckNameAvailability_567880, base: "",
    url: url_VaultsCheckNameAvailability_567881, schemes: {Scheme.Https})
type
  Call_VaultsListDeleted_568210 = ref object of OpenApiRestCall_567657
proc url_VaultsListDeleted_568212(protocol: Scheme; host: string; base: string;
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
        value: "/providers/Microsoft.KeyVault/deletedVaults")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VaultsListDeleted_568211(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Gets information about the deleted vaults in a subscription.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_568213 = path.getOrDefault("subscriptionId")
  valid_568213 = validateParameter(valid_568213, JString, required = true,
                                 default = nil)
  if valid_568213 != nil:
    section.add "subscriptionId", valid_568213
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568214 = query.getOrDefault("api-version")
  valid_568214 = validateParameter(valid_568214, JString, required = true,
                                 default = nil)
  if valid_568214 != nil:
    section.add "api-version", valid_568214
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568215: Call_VaultsListDeleted_568210; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets information about the deleted vaults in a subscription.
  ## 
  let valid = call_568215.validator(path, query, header, formData, body)
  let scheme = call_568215.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568215.url(scheme.get, call_568215.host, call_568215.base,
                         call_568215.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568215, url, valid)

proc call*(call_568216: Call_VaultsListDeleted_568210; apiVersion: string;
          subscriptionId: string): Recallable =
  ## vaultsListDeleted
  ## Gets information about the deleted vaults in a subscription.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_568217 = newJObject()
  var query_568218 = newJObject()
  add(query_568218, "api-version", newJString(apiVersion))
  add(path_568217, "subscriptionId", newJString(subscriptionId))
  result = call_568216.call(path_568217, query_568218, nil, nil, nil)

var vaultsListDeleted* = Call_VaultsListDeleted_568210(name: "vaultsListDeleted",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.KeyVault/deletedVaults",
    validator: validate_VaultsListDeleted_568211, base: "",
    url: url_VaultsListDeleted_568212, schemes: {Scheme.Https})
type
  Call_VaultsGetDeleted_568219 = ref object of OpenApiRestCall_567657
proc url_VaultsGetDeleted_568221(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "location" in path, "`location` is a required path parameter"
  assert "vaultName" in path, "`vaultName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment, value: "/providers/Microsoft.KeyVault/locations/"),
               (kind: VariableSegment, value: "location"),
               (kind: ConstantSegment, value: "/deletedVaults/"),
               (kind: VariableSegment, value: "vaultName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VaultsGetDeleted_568220(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Gets the deleted Azure key vault.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   vaultName: JString (required)
  ##            : The name of the vault.
  ##   location: JString (required)
  ##           : The location of the deleted vault.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_568222 = path.getOrDefault("subscriptionId")
  valid_568222 = validateParameter(valid_568222, JString, required = true,
                                 default = nil)
  if valid_568222 != nil:
    section.add "subscriptionId", valid_568222
  var valid_568223 = path.getOrDefault("vaultName")
  valid_568223 = validateParameter(valid_568223, JString, required = true,
                                 default = nil)
  if valid_568223 != nil:
    section.add "vaultName", valid_568223
  var valid_568224 = path.getOrDefault("location")
  valid_568224 = validateParameter(valid_568224, JString, required = true,
                                 default = nil)
  if valid_568224 != nil:
    section.add "location", valid_568224
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568225 = query.getOrDefault("api-version")
  valid_568225 = validateParameter(valid_568225, JString, required = true,
                                 default = nil)
  if valid_568225 != nil:
    section.add "api-version", valid_568225
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568226: Call_VaultsGetDeleted_568219; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the deleted Azure key vault.
  ## 
  let valid = call_568226.validator(path, query, header, formData, body)
  let scheme = call_568226.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568226.url(scheme.get, call_568226.host, call_568226.base,
                         call_568226.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568226, url, valid)

proc call*(call_568227: Call_VaultsGetDeleted_568219; apiVersion: string;
          subscriptionId: string; vaultName: string; location: string): Recallable =
  ## vaultsGetDeleted
  ## Gets the deleted Azure key vault.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   vaultName: string (required)
  ##            : The name of the vault.
  ##   location: string (required)
  ##           : The location of the deleted vault.
  var path_568228 = newJObject()
  var query_568229 = newJObject()
  add(query_568229, "api-version", newJString(apiVersion))
  add(path_568228, "subscriptionId", newJString(subscriptionId))
  add(path_568228, "vaultName", newJString(vaultName))
  add(path_568228, "location", newJString(location))
  result = call_568227.call(path_568228, query_568229, nil, nil, nil)

var vaultsGetDeleted* = Call_VaultsGetDeleted_568219(name: "vaultsGetDeleted",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.KeyVault/locations/{location}/deletedVaults/{vaultName}",
    validator: validate_VaultsGetDeleted_568220, base: "",
    url: url_VaultsGetDeleted_568221, schemes: {Scheme.Https})
type
  Call_VaultsPurgeDeleted_568230 = ref object of OpenApiRestCall_567657
proc url_VaultsPurgeDeleted_568232(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "location" in path, "`location` is a required path parameter"
  assert "vaultName" in path, "`vaultName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment, value: "/providers/Microsoft.KeyVault/locations/"),
               (kind: VariableSegment, value: "location"),
               (kind: ConstantSegment, value: "/deletedVaults/"),
               (kind: VariableSegment, value: "vaultName"),
               (kind: ConstantSegment, value: "/purge")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VaultsPurgeDeleted_568231(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Permanently deletes the specified vault. aka Purges the deleted Azure key vault.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   vaultName: JString (required)
  ##            : The name of the soft-deleted vault.
  ##   location: JString (required)
  ##           : The location of the soft-deleted vault.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_568233 = path.getOrDefault("subscriptionId")
  valid_568233 = validateParameter(valid_568233, JString, required = true,
                                 default = nil)
  if valid_568233 != nil:
    section.add "subscriptionId", valid_568233
  var valid_568234 = path.getOrDefault("vaultName")
  valid_568234 = validateParameter(valid_568234, JString, required = true,
                                 default = nil)
  if valid_568234 != nil:
    section.add "vaultName", valid_568234
  var valid_568235 = path.getOrDefault("location")
  valid_568235 = validateParameter(valid_568235, JString, required = true,
                                 default = nil)
  if valid_568235 != nil:
    section.add "location", valid_568235
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568236 = query.getOrDefault("api-version")
  valid_568236 = validateParameter(valid_568236, JString, required = true,
                                 default = nil)
  if valid_568236 != nil:
    section.add "api-version", valid_568236
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568237: Call_VaultsPurgeDeleted_568230; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Permanently deletes the specified vault. aka Purges the deleted Azure key vault.
  ## 
  let valid = call_568237.validator(path, query, header, formData, body)
  let scheme = call_568237.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568237.url(scheme.get, call_568237.host, call_568237.base,
                         call_568237.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568237, url, valid)

proc call*(call_568238: Call_VaultsPurgeDeleted_568230; apiVersion: string;
          subscriptionId: string; vaultName: string; location: string): Recallable =
  ## vaultsPurgeDeleted
  ## Permanently deletes the specified vault. aka Purges the deleted Azure key vault.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   vaultName: string (required)
  ##            : The name of the soft-deleted vault.
  ##   location: string (required)
  ##           : The location of the soft-deleted vault.
  var path_568239 = newJObject()
  var query_568240 = newJObject()
  add(query_568240, "api-version", newJString(apiVersion))
  add(path_568239, "subscriptionId", newJString(subscriptionId))
  add(path_568239, "vaultName", newJString(vaultName))
  add(path_568239, "location", newJString(location))
  result = call_568238.call(path_568239, query_568240, nil, nil, nil)

var vaultsPurgeDeleted* = Call_VaultsPurgeDeleted_568230(
    name: "vaultsPurgeDeleted", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.KeyVault/locations/{location}/deletedVaults/{vaultName}/purge",
    validator: validate_VaultsPurgeDeleted_568231, base: "",
    url: url_VaultsPurgeDeleted_568232, schemes: {Scheme.Https})
type
  Call_VaultsListBySubscription_568241 = ref object of OpenApiRestCall_567657
proc url_VaultsListBySubscription_568243(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment, value: "/providers/Microsoft.KeyVault/vaults")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VaultsListBySubscription_568242(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The List operation gets information about the vaults associated with the subscription.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_568245 = path.getOrDefault("subscriptionId")
  valid_568245 = validateParameter(valid_568245, JString, required = true,
                                 default = nil)
  if valid_568245 != nil:
    section.add "subscriptionId", valid_568245
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   $top: JInt
  ##       : Maximum number of results to return.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568246 = query.getOrDefault("api-version")
  valid_568246 = validateParameter(valid_568246, JString, required = true,
                                 default = nil)
  if valid_568246 != nil:
    section.add "api-version", valid_568246
  var valid_568247 = query.getOrDefault("$top")
  valid_568247 = validateParameter(valid_568247, JInt, required = false, default = nil)
  if valid_568247 != nil:
    section.add "$top", valid_568247
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568248: Call_VaultsListBySubscription_568241; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The List operation gets information about the vaults associated with the subscription.
  ## 
  let valid = call_568248.validator(path, query, header, formData, body)
  let scheme = call_568248.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568248.url(scheme.get, call_568248.host, call_568248.base,
                         call_568248.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568248, url, valid)

proc call*(call_568249: Call_VaultsListBySubscription_568241; apiVersion: string;
          subscriptionId: string; Top: int = 0): Recallable =
  ## vaultsListBySubscription
  ## The List operation gets information about the vaults associated with the subscription.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   Top: int
  ##      : Maximum number of results to return.
  var path_568250 = newJObject()
  var query_568251 = newJObject()
  add(query_568251, "api-version", newJString(apiVersion))
  add(path_568250, "subscriptionId", newJString(subscriptionId))
  add(query_568251, "$top", newJInt(Top))
  result = call_568249.call(path_568250, query_568251, nil, nil, nil)

var vaultsListBySubscription* = Call_VaultsListBySubscription_568241(
    name: "vaultsListBySubscription", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.KeyVault/vaults",
    validator: validate_VaultsListBySubscription_568242, base: "",
    url: url_VaultsListBySubscription_568243, schemes: {Scheme.Https})
type
  Call_VaultsListByResourceGroup_568252 = ref object of OpenApiRestCall_567657
proc url_VaultsListByResourceGroup_568254(protocol: Scheme; host: string;
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
        kind: ConstantSegment, value: "/providers/Microsoft.KeyVault/vaults")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VaultsListByResourceGroup_568253(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The List operation gets information about the vaults associated with the subscription and within the specified resource group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the Resource Group to which the vault belongs.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568255 = path.getOrDefault("resourceGroupName")
  valid_568255 = validateParameter(valid_568255, JString, required = true,
                                 default = nil)
  if valid_568255 != nil:
    section.add "resourceGroupName", valid_568255
  var valid_568256 = path.getOrDefault("subscriptionId")
  valid_568256 = validateParameter(valid_568256, JString, required = true,
                                 default = nil)
  if valid_568256 != nil:
    section.add "subscriptionId", valid_568256
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   $top: JInt
  ##       : Maximum number of results to return.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568257 = query.getOrDefault("api-version")
  valid_568257 = validateParameter(valid_568257, JString, required = true,
                                 default = nil)
  if valid_568257 != nil:
    section.add "api-version", valid_568257
  var valid_568258 = query.getOrDefault("$top")
  valid_568258 = validateParameter(valid_568258, JInt, required = false, default = nil)
  if valid_568258 != nil:
    section.add "$top", valid_568258
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568259: Call_VaultsListByResourceGroup_568252; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The List operation gets information about the vaults associated with the subscription and within the specified resource group.
  ## 
  let valid = call_568259.validator(path, query, header, formData, body)
  let scheme = call_568259.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568259.url(scheme.get, call_568259.host, call_568259.base,
                         call_568259.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568259, url, valid)

proc call*(call_568260: Call_VaultsListByResourceGroup_568252;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          Top: int = 0): Recallable =
  ## vaultsListByResourceGroup
  ## The List operation gets information about the vaults associated with the subscription and within the specified resource group.
  ##   resourceGroupName: string (required)
  ##                    : The name of the Resource Group to which the vault belongs.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   Top: int
  ##      : Maximum number of results to return.
  var path_568261 = newJObject()
  var query_568262 = newJObject()
  add(path_568261, "resourceGroupName", newJString(resourceGroupName))
  add(query_568262, "api-version", newJString(apiVersion))
  add(path_568261, "subscriptionId", newJString(subscriptionId))
  add(query_568262, "$top", newJInt(Top))
  result = call_568260.call(path_568261, query_568262, nil, nil, nil)

var vaultsListByResourceGroup* = Call_VaultsListByResourceGroup_568252(
    name: "vaultsListByResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.KeyVault/vaults",
    validator: validate_VaultsListByResourceGroup_568253, base: "",
    url: url_VaultsListByResourceGroup_568254, schemes: {Scheme.Https})
type
  Call_VaultsCreateOrUpdate_568274 = ref object of OpenApiRestCall_567657
proc url_VaultsCreateOrUpdate_568276(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "vaultName" in path, "`vaultName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.KeyVault/vaults/"),
               (kind: VariableSegment, value: "vaultName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VaultsCreateOrUpdate_568275(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create or update a key vault in the specified subscription.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the Resource Group to which the server belongs.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   vaultName: JString (required)
  ##            : Name of the vault
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568277 = path.getOrDefault("resourceGroupName")
  valid_568277 = validateParameter(valid_568277, JString, required = true,
                                 default = nil)
  if valid_568277 != nil:
    section.add "resourceGroupName", valid_568277
  var valid_568278 = path.getOrDefault("subscriptionId")
  valid_568278 = validateParameter(valid_568278, JString, required = true,
                                 default = nil)
  if valid_568278 != nil:
    section.add "subscriptionId", valid_568278
  var valid_568279 = path.getOrDefault("vaultName")
  valid_568279 = validateParameter(valid_568279, JString, required = true,
                                 default = nil)
  if valid_568279 != nil:
    section.add "vaultName", valid_568279
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568280 = query.getOrDefault("api-version")
  valid_568280 = validateParameter(valid_568280, JString, required = true,
                                 default = nil)
  if valid_568280 != nil:
    section.add "api-version", valid_568280
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters to create or update the vault
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568282: Call_VaultsCreateOrUpdate_568274; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create or update a key vault in the specified subscription.
  ## 
  let valid = call_568282.validator(path, query, header, formData, body)
  let scheme = call_568282.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568282.url(scheme.get, call_568282.host, call_568282.base,
                         call_568282.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568282, url, valid)

proc call*(call_568283: Call_VaultsCreateOrUpdate_568274;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          vaultName: string; parameters: JsonNode): Recallable =
  ## vaultsCreateOrUpdate
  ## Create or update a key vault in the specified subscription.
  ##   resourceGroupName: string (required)
  ##                    : The name of the Resource Group to which the server belongs.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   vaultName: string (required)
  ##            : Name of the vault
  ##   parameters: JObject (required)
  ##             : Parameters to create or update the vault
  var path_568284 = newJObject()
  var query_568285 = newJObject()
  var body_568286 = newJObject()
  add(path_568284, "resourceGroupName", newJString(resourceGroupName))
  add(query_568285, "api-version", newJString(apiVersion))
  add(path_568284, "subscriptionId", newJString(subscriptionId))
  add(path_568284, "vaultName", newJString(vaultName))
  if parameters != nil:
    body_568286 = parameters
  result = call_568283.call(path_568284, query_568285, nil, nil, body_568286)

var vaultsCreateOrUpdate* = Call_VaultsCreateOrUpdate_568274(
    name: "vaultsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.KeyVault/vaults/{vaultName}",
    validator: validate_VaultsCreateOrUpdate_568275, base: "",
    url: url_VaultsCreateOrUpdate_568276, schemes: {Scheme.Https})
type
  Call_VaultsGet_568263 = ref object of OpenApiRestCall_567657
proc url_VaultsGet_568265(protocol: Scheme; host: string; base: string; route: string;
                         path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "vaultName" in path, "`vaultName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.KeyVault/vaults/"),
               (kind: VariableSegment, value: "vaultName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VaultsGet_568264(path: JsonNode; query: JsonNode; header: JsonNode;
                              formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the specified Azure key vault.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the Resource Group to which the vault belongs.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   vaultName: JString (required)
  ##            : The name of the vault.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568266 = path.getOrDefault("resourceGroupName")
  valid_568266 = validateParameter(valid_568266, JString, required = true,
                                 default = nil)
  if valid_568266 != nil:
    section.add "resourceGroupName", valid_568266
  var valid_568267 = path.getOrDefault("subscriptionId")
  valid_568267 = validateParameter(valid_568267, JString, required = true,
                                 default = nil)
  if valid_568267 != nil:
    section.add "subscriptionId", valid_568267
  var valid_568268 = path.getOrDefault("vaultName")
  valid_568268 = validateParameter(valid_568268, JString, required = true,
                                 default = nil)
  if valid_568268 != nil:
    section.add "vaultName", valid_568268
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568269 = query.getOrDefault("api-version")
  valid_568269 = validateParameter(valid_568269, JString, required = true,
                                 default = nil)
  if valid_568269 != nil:
    section.add "api-version", valid_568269
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568270: Call_VaultsGet_568263; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the specified Azure key vault.
  ## 
  let valid = call_568270.validator(path, query, header, formData, body)
  let scheme = call_568270.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568270.url(scheme.get, call_568270.host, call_568270.base,
                         call_568270.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568270, url, valid)

proc call*(call_568271: Call_VaultsGet_568263; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; vaultName: string): Recallable =
  ## vaultsGet
  ## Gets the specified Azure key vault.
  ##   resourceGroupName: string (required)
  ##                    : The name of the Resource Group to which the vault belongs.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   vaultName: string (required)
  ##            : The name of the vault.
  var path_568272 = newJObject()
  var query_568273 = newJObject()
  add(path_568272, "resourceGroupName", newJString(resourceGroupName))
  add(query_568273, "api-version", newJString(apiVersion))
  add(path_568272, "subscriptionId", newJString(subscriptionId))
  add(path_568272, "vaultName", newJString(vaultName))
  result = call_568271.call(path_568272, query_568273, nil, nil, nil)

var vaultsGet* = Call_VaultsGet_568263(name: "vaultsGet", meth: HttpMethod.HttpGet,
                                    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.KeyVault/vaults/{vaultName}",
                                    validator: validate_VaultsGet_568264,
                                    base: "", url: url_VaultsGet_568265,
                                    schemes: {Scheme.Https})
type
  Call_VaultsUpdate_568298 = ref object of OpenApiRestCall_567657
proc url_VaultsUpdate_568300(protocol: Scheme; host: string; base: string;
                            route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "vaultName" in path, "`vaultName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.KeyVault/vaults/"),
               (kind: VariableSegment, value: "vaultName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VaultsUpdate_568299(path: JsonNode; query: JsonNode; header: JsonNode;
                                 formData: JsonNode; body: JsonNode): JsonNode =
  ## Update a key vault in the specified subscription.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the Resource Group to which the server belongs.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   vaultName: JString (required)
  ##            : Name of the vault
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568301 = path.getOrDefault("resourceGroupName")
  valid_568301 = validateParameter(valid_568301, JString, required = true,
                                 default = nil)
  if valid_568301 != nil:
    section.add "resourceGroupName", valid_568301
  var valid_568302 = path.getOrDefault("subscriptionId")
  valid_568302 = validateParameter(valid_568302, JString, required = true,
                                 default = nil)
  if valid_568302 != nil:
    section.add "subscriptionId", valid_568302
  var valid_568303 = path.getOrDefault("vaultName")
  valid_568303 = validateParameter(valid_568303, JString, required = true,
                                 default = nil)
  if valid_568303 != nil:
    section.add "vaultName", valid_568303
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568304 = query.getOrDefault("api-version")
  valid_568304 = validateParameter(valid_568304, JString, required = true,
                                 default = nil)
  if valid_568304 != nil:
    section.add "api-version", valid_568304
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters to patch the vault
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568306: Call_VaultsUpdate_568298; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Update a key vault in the specified subscription.
  ## 
  let valid = call_568306.validator(path, query, header, formData, body)
  let scheme = call_568306.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568306.url(scheme.get, call_568306.host, call_568306.base,
                         call_568306.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568306, url, valid)

proc call*(call_568307: Call_VaultsUpdate_568298; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; vaultName: string;
          parameters: JsonNode): Recallable =
  ## vaultsUpdate
  ## Update a key vault in the specified subscription.
  ##   resourceGroupName: string (required)
  ##                    : The name of the Resource Group to which the server belongs.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   vaultName: string (required)
  ##            : Name of the vault
  ##   parameters: JObject (required)
  ##             : Parameters to patch the vault
  var path_568308 = newJObject()
  var query_568309 = newJObject()
  var body_568310 = newJObject()
  add(path_568308, "resourceGroupName", newJString(resourceGroupName))
  add(query_568309, "api-version", newJString(apiVersion))
  add(path_568308, "subscriptionId", newJString(subscriptionId))
  add(path_568308, "vaultName", newJString(vaultName))
  if parameters != nil:
    body_568310 = parameters
  result = call_568307.call(path_568308, query_568309, nil, nil, body_568310)

var vaultsUpdate* = Call_VaultsUpdate_568298(name: "vaultsUpdate",
    meth: HttpMethod.HttpPatch, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.KeyVault/vaults/{vaultName}",
    validator: validate_VaultsUpdate_568299, base: "", url: url_VaultsUpdate_568300,
    schemes: {Scheme.Https})
type
  Call_VaultsDelete_568287 = ref object of OpenApiRestCall_567657
proc url_VaultsDelete_568289(protocol: Scheme; host: string; base: string;
                            route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "vaultName" in path, "`vaultName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.KeyVault/vaults/"),
               (kind: VariableSegment, value: "vaultName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VaultsDelete_568288(path: JsonNode; query: JsonNode; header: JsonNode;
                                 formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes the specified Azure key vault.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the Resource Group to which the vault belongs.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   vaultName: JString (required)
  ##            : The name of the vault to delete
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568290 = path.getOrDefault("resourceGroupName")
  valid_568290 = validateParameter(valid_568290, JString, required = true,
                                 default = nil)
  if valid_568290 != nil:
    section.add "resourceGroupName", valid_568290
  var valid_568291 = path.getOrDefault("subscriptionId")
  valid_568291 = validateParameter(valid_568291, JString, required = true,
                                 default = nil)
  if valid_568291 != nil:
    section.add "subscriptionId", valid_568291
  var valid_568292 = path.getOrDefault("vaultName")
  valid_568292 = validateParameter(valid_568292, JString, required = true,
                                 default = nil)
  if valid_568292 != nil:
    section.add "vaultName", valid_568292
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568293 = query.getOrDefault("api-version")
  valid_568293 = validateParameter(valid_568293, JString, required = true,
                                 default = nil)
  if valid_568293 != nil:
    section.add "api-version", valid_568293
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568294: Call_VaultsDelete_568287; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the specified Azure key vault.
  ## 
  let valid = call_568294.validator(path, query, header, formData, body)
  let scheme = call_568294.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568294.url(scheme.get, call_568294.host, call_568294.base,
                         call_568294.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568294, url, valid)

proc call*(call_568295: Call_VaultsDelete_568287; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; vaultName: string): Recallable =
  ## vaultsDelete
  ## Deletes the specified Azure key vault.
  ##   resourceGroupName: string (required)
  ##                    : The name of the Resource Group to which the vault belongs.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   vaultName: string (required)
  ##            : The name of the vault to delete
  var path_568296 = newJObject()
  var query_568297 = newJObject()
  add(path_568296, "resourceGroupName", newJString(resourceGroupName))
  add(query_568297, "api-version", newJString(apiVersion))
  add(path_568296, "subscriptionId", newJString(subscriptionId))
  add(path_568296, "vaultName", newJString(vaultName))
  result = call_568295.call(path_568296, query_568297, nil, nil, nil)

var vaultsDelete* = Call_VaultsDelete_568287(name: "vaultsDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.KeyVault/vaults/{vaultName}",
    validator: validate_VaultsDelete_568288, base: "", url: url_VaultsDelete_568289,
    schemes: {Scheme.Https})
type
  Call_VaultsUpdateAccessPolicy_568311 = ref object of OpenApiRestCall_567657
proc url_VaultsUpdateAccessPolicy_568313(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "vaultName" in path, "`vaultName` is a required path parameter"
  assert "operationKind" in path, "`operationKind` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.KeyVault/vaults/"),
               (kind: VariableSegment, value: "vaultName"),
               (kind: ConstantSegment, value: "/accessPolicies/"),
               (kind: VariableSegment, value: "operationKind")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VaultsUpdateAccessPolicy_568312(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Update access policies in a key vault in the specified subscription.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the Resource Group to which the vault belongs.
  ##   operationKind: JString (required)
  ##                : Name of the operation
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   vaultName: JString (required)
  ##            : Name of the vault
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568314 = path.getOrDefault("resourceGroupName")
  valid_568314 = validateParameter(valid_568314, JString, required = true,
                                 default = nil)
  if valid_568314 != nil:
    section.add "resourceGroupName", valid_568314
  var valid_568328 = path.getOrDefault("operationKind")
  valid_568328 = validateParameter(valid_568328, JString, required = true,
                                 default = newJString("add"))
  if valid_568328 != nil:
    section.add "operationKind", valid_568328
  var valid_568329 = path.getOrDefault("subscriptionId")
  valid_568329 = validateParameter(valid_568329, JString, required = true,
                                 default = nil)
  if valid_568329 != nil:
    section.add "subscriptionId", valid_568329
  var valid_568330 = path.getOrDefault("vaultName")
  valid_568330 = validateParameter(valid_568330, JString, required = true,
                                 default = nil)
  if valid_568330 != nil:
    section.add "vaultName", valid_568330
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568331 = query.getOrDefault("api-version")
  valid_568331 = validateParameter(valid_568331, JString, required = true,
                                 default = nil)
  if valid_568331 != nil:
    section.add "api-version", valid_568331
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Access policy to merge into the vault
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568333: Call_VaultsUpdateAccessPolicy_568311; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Update access policies in a key vault in the specified subscription.
  ## 
  let valid = call_568333.validator(path, query, header, formData, body)
  let scheme = call_568333.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568333.url(scheme.get, call_568333.host, call_568333.base,
                         call_568333.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568333, url, valid)

proc call*(call_568334: Call_VaultsUpdateAccessPolicy_568311;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          vaultName: string; parameters: JsonNode; operationKind: string = "add"): Recallable =
  ## vaultsUpdateAccessPolicy
  ## Update access policies in a key vault in the specified subscription.
  ##   resourceGroupName: string (required)
  ##                    : The name of the Resource Group to which the vault belongs.
  ##   operationKind: string (required)
  ##                : Name of the operation
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   vaultName: string (required)
  ##            : Name of the vault
  ##   parameters: JObject (required)
  ##             : Access policy to merge into the vault
  var path_568335 = newJObject()
  var query_568336 = newJObject()
  var body_568337 = newJObject()
  add(path_568335, "resourceGroupName", newJString(resourceGroupName))
  add(path_568335, "operationKind", newJString(operationKind))
  add(query_568336, "api-version", newJString(apiVersion))
  add(path_568335, "subscriptionId", newJString(subscriptionId))
  add(path_568335, "vaultName", newJString(vaultName))
  if parameters != nil:
    body_568337 = parameters
  result = call_568334.call(path_568335, query_568336, nil, nil, body_568337)

var vaultsUpdateAccessPolicy* = Call_VaultsUpdateAccessPolicy_568311(
    name: "vaultsUpdateAccessPolicy", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.KeyVault/vaults/{vaultName}/accessPolicies/{operationKind}",
    validator: validate_VaultsUpdateAccessPolicy_568312, base: "",
    url: url_VaultsUpdateAccessPolicy_568313, schemes: {Scheme.Https})
type
  Call_VaultsList_568338 = ref object of OpenApiRestCall_567657
proc url_VaultsList_568340(protocol: Scheme; host: string; base: string; route: string;
                          path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resources")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VaultsList_568339(path: JsonNode; query: JsonNode; header: JsonNode;
                               formData: JsonNode; body: JsonNode): JsonNode =
  ## The List operation gets information about the vaults associated with the subscription.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_568341 = path.getOrDefault("subscriptionId")
  valid_568341 = validateParameter(valid_568341, JString, required = true,
                                 default = nil)
  if valid_568341 != nil:
    section.add "subscriptionId", valid_568341
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Azure Resource Manager Api Version.
  ##   $top: JInt
  ##       : Maximum number of results to return.
  ##   $filter: JString (required)
  ##          : The filter to apply on the operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568342 = query.getOrDefault("api-version")
  valid_568342 = validateParameter(valid_568342, JString, required = true,
                                 default = newJString("2015-11-01"))
  if valid_568342 != nil:
    section.add "api-version", valid_568342
  var valid_568343 = query.getOrDefault("$top")
  valid_568343 = validateParameter(valid_568343, JInt, required = false, default = nil)
  if valid_568343 != nil:
    section.add "$top", valid_568343
  var valid_568344 = query.getOrDefault("$filter")
  valid_568344 = validateParameter(valid_568344, JString, required = true, default = newJString(
      "resourceType eq \'Microsoft.KeyVault/vaults\'"))
  if valid_568344 != nil:
    section.add "$filter", valid_568344
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568345: Call_VaultsList_568338; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The List operation gets information about the vaults associated with the subscription.
  ## 
  let valid = call_568345.validator(path, query, header, formData, body)
  let scheme = call_568345.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568345.url(scheme.get, call_568345.host, call_568345.base,
                         call_568345.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568345, url, valid)

proc call*(call_568346: Call_VaultsList_568338; subscriptionId: string;
          apiVersion: string = "2015-11-01"; Top: int = 0;
          Filter: string = "resourceType eq \'Microsoft.KeyVault/vaults\'"): Recallable =
  ## vaultsList
  ## The List operation gets information about the vaults associated with the subscription.
  ##   apiVersion: string (required)
  ##             : Azure Resource Manager Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   Top: int
  ##      : Maximum number of results to return.
  ##   Filter: string (required)
  ##         : The filter to apply on the operation.
  var path_568347 = newJObject()
  var query_568348 = newJObject()
  add(query_568348, "api-version", newJString(apiVersion))
  add(path_568347, "subscriptionId", newJString(subscriptionId))
  add(query_568348, "$top", newJInt(Top))
  add(query_568348, "$filter", newJString(Filter))
  result = call_568346.call(path_568347, query_568348, nil, nil, nil)

var vaultsList* = Call_VaultsList_568338(name: "vaultsList",
                                      meth: HttpMethod.HttpGet,
                                      host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resources",
                                      validator: validate_VaultsList_568339,
                                      base: "", url: url_VaultsList_568340,
                                      schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)

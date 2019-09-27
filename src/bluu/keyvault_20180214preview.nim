
import
  json, options, hashes, uri, openapi/rest, os, uri, strutils, httpcore

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

  OpenApiRestCall_593424 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_593424](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_593424): Option[Scheme] {.used.} =
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
  macServiceName = "keyvault"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_VaultsCheckNameAvailability_593646 = ref object of OpenApiRestCall_593424
proc url_VaultsCheckNameAvailability_593648(protocol: Scheme; host: string;
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

proc validate_VaultsCheckNameAvailability_593647(path: JsonNode; query: JsonNode;
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
  var valid_593838 = path.getOrDefault("subscriptionId")
  valid_593838 = validateParameter(valid_593838, JString, required = true,
                                 default = nil)
  if valid_593838 != nil:
    section.add "subscriptionId", valid_593838
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593839 = query.getOrDefault("api-version")
  valid_593839 = validateParameter(valid_593839, JString, required = true,
                                 default = nil)
  if valid_593839 != nil:
    section.add "api-version", valid_593839
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

proc call*(call_593863: Call_VaultsCheckNameAvailability_593646; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Checks that the vault name is valid and is not already in use.
  ## 
  let valid = call_593863.validator(path, query, header, formData, body)
  let scheme = call_593863.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593863.url(scheme.get, call_593863.host, call_593863.base,
                         call_593863.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593863, url, valid)

proc call*(call_593934: Call_VaultsCheckNameAvailability_593646;
          apiVersion: string; subscriptionId: string; vaultName: JsonNode): Recallable =
  ## vaultsCheckNameAvailability
  ## Checks that the vault name is valid and is not already in use.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   vaultName: JObject (required)
  ##            : The name of the vault.
  var path_593935 = newJObject()
  var query_593937 = newJObject()
  var body_593938 = newJObject()
  add(query_593937, "api-version", newJString(apiVersion))
  add(path_593935, "subscriptionId", newJString(subscriptionId))
  if vaultName != nil:
    body_593938 = vaultName
  result = call_593934.call(path_593935, query_593937, nil, nil, body_593938)

var vaultsCheckNameAvailability* = Call_VaultsCheckNameAvailability_593646(
    name: "vaultsCheckNameAvailability", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.KeyVault/checkNameAvailability",
    validator: validate_VaultsCheckNameAvailability_593647, base: "",
    url: url_VaultsCheckNameAvailability_593648, schemes: {Scheme.Https})
type
  Call_VaultsListDeleted_593977 = ref object of OpenApiRestCall_593424
proc url_VaultsListDeleted_593979(protocol: Scheme; host: string; base: string;
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

proc validate_VaultsListDeleted_593978(path: JsonNode; query: JsonNode;
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
  var valid_593980 = path.getOrDefault("subscriptionId")
  valid_593980 = validateParameter(valid_593980, JString, required = true,
                                 default = nil)
  if valid_593980 != nil:
    section.add "subscriptionId", valid_593980
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593981 = query.getOrDefault("api-version")
  valid_593981 = validateParameter(valid_593981, JString, required = true,
                                 default = nil)
  if valid_593981 != nil:
    section.add "api-version", valid_593981
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593982: Call_VaultsListDeleted_593977; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets information about the deleted vaults in a subscription.
  ## 
  let valid = call_593982.validator(path, query, header, formData, body)
  let scheme = call_593982.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593982.url(scheme.get, call_593982.host, call_593982.base,
                         call_593982.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593982, url, valid)

proc call*(call_593983: Call_VaultsListDeleted_593977; apiVersion: string;
          subscriptionId: string): Recallable =
  ## vaultsListDeleted
  ## Gets information about the deleted vaults in a subscription.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_593984 = newJObject()
  var query_593985 = newJObject()
  add(query_593985, "api-version", newJString(apiVersion))
  add(path_593984, "subscriptionId", newJString(subscriptionId))
  result = call_593983.call(path_593984, query_593985, nil, nil, nil)

var vaultsListDeleted* = Call_VaultsListDeleted_593977(name: "vaultsListDeleted",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.KeyVault/deletedVaults",
    validator: validate_VaultsListDeleted_593978, base: "",
    url: url_VaultsListDeleted_593979, schemes: {Scheme.Https})
type
  Call_VaultsGetDeleted_593986 = ref object of OpenApiRestCall_593424
proc url_VaultsGetDeleted_593988(protocol: Scheme; host: string; base: string;
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

proc validate_VaultsGetDeleted_593987(path: JsonNode; query: JsonNode;
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
  var valid_593989 = path.getOrDefault("subscriptionId")
  valid_593989 = validateParameter(valid_593989, JString, required = true,
                                 default = nil)
  if valid_593989 != nil:
    section.add "subscriptionId", valid_593989
  var valid_593990 = path.getOrDefault("vaultName")
  valid_593990 = validateParameter(valid_593990, JString, required = true,
                                 default = nil)
  if valid_593990 != nil:
    section.add "vaultName", valid_593990
  var valid_593991 = path.getOrDefault("location")
  valid_593991 = validateParameter(valid_593991, JString, required = true,
                                 default = nil)
  if valid_593991 != nil:
    section.add "location", valid_593991
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593992 = query.getOrDefault("api-version")
  valid_593992 = validateParameter(valid_593992, JString, required = true,
                                 default = nil)
  if valid_593992 != nil:
    section.add "api-version", valid_593992
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593993: Call_VaultsGetDeleted_593986; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the deleted Azure key vault.
  ## 
  let valid = call_593993.validator(path, query, header, formData, body)
  let scheme = call_593993.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593993.url(scheme.get, call_593993.host, call_593993.base,
                         call_593993.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593993, url, valid)

proc call*(call_593994: Call_VaultsGetDeleted_593986; apiVersion: string;
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
  var path_593995 = newJObject()
  var query_593996 = newJObject()
  add(query_593996, "api-version", newJString(apiVersion))
  add(path_593995, "subscriptionId", newJString(subscriptionId))
  add(path_593995, "vaultName", newJString(vaultName))
  add(path_593995, "location", newJString(location))
  result = call_593994.call(path_593995, query_593996, nil, nil, nil)

var vaultsGetDeleted* = Call_VaultsGetDeleted_593986(name: "vaultsGetDeleted",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.KeyVault/locations/{location}/deletedVaults/{vaultName}",
    validator: validate_VaultsGetDeleted_593987, base: "",
    url: url_VaultsGetDeleted_593988, schemes: {Scheme.Https})
type
  Call_VaultsPurgeDeleted_593997 = ref object of OpenApiRestCall_593424
proc url_VaultsPurgeDeleted_593999(protocol: Scheme; host: string; base: string;
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

proc validate_VaultsPurgeDeleted_593998(path: JsonNode; query: JsonNode;
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
  var valid_594000 = path.getOrDefault("subscriptionId")
  valid_594000 = validateParameter(valid_594000, JString, required = true,
                                 default = nil)
  if valid_594000 != nil:
    section.add "subscriptionId", valid_594000
  var valid_594001 = path.getOrDefault("vaultName")
  valid_594001 = validateParameter(valid_594001, JString, required = true,
                                 default = nil)
  if valid_594001 != nil:
    section.add "vaultName", valid_594001
  var valid_594002 = path.getOrDefault("location")
  valid_594002 = validateParameter(valid_594002, JString, required = true,
                                 default = nil)
  if valid_594002 != nil:
    section.add "location", valid_594002
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594003 = query.getOrDefault("api-version")
  valid_594003 = validateParameter(valid_594003, JString, required = true,
                                 default = nil)
  if valid_594003 != nil:
    section.add "api-version", valid_594003
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594004: Call_VaultsPurgeDeleted_593997; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Permanently deletes the specified vault. aka Purges the deleted Azure key vault.
  ## 
  let valid = call_594004.validator(path, query, header, formData, body)
  let scheme = call_594004.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594004.url(scheme.get, call_594004.host, call_594004.base,
                         call_594004.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594004, url, valid)

proc call*(call_594005: Call_VaultsPurgeDeleted_593997; apiVersion: string;
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
  var path_594006 = newJObject()
  var query_594007 = newJObject()
  add(query_594007, "api-version", newJString(apiVersion))
  add(path_594006, "subscriptionId", newJString(subscriptionId))
  add(path_594006, "vaultName", newJString(vaultName))
  add(path_594006, "location", newJString(location))
  result = call_594005.call(path_594006, query_594007, nil, nil, nil)

var vaultsPurgeDeleted* = Call_VaultsPurgeDeleted_593997(
    name: "vaultsPurgeDeleted", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.KeyVault/locations/{location}/deletedVaults/{vaultName}/purge",
    validator: validate_VaultsPurgeDeleted_593998, base: "",
    url: url_VaultsPurgeDeleted_593999, schemes: {Scheme.Https})
type
  Call_VaultsListBySubscription_594008 = ref object of OpenApiRestCall_593424
proc url_VaultsListBySubscription_594010(protocol: Scheme; host: string;
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

proc validate_VaultsListBySubscription_594009(path: JsonNode; query: JsonNode;
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
  var valid_594012 = path.getOrDefault("subscriptionId")
  valid_594012 = validateParameter(valid_594012, JString, required = true,
                                 default = nil)
  if valid_594012 != nil:
    section.add "subscriptionId", valid_594012
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   $top: JInt
  ##       : Maximum number of results to return.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594013 = query.getOrDefault("api-version")
  valid_594013 = validateParameter(valid_594013, JString, required = true,
                                 default = nil)
  if valid_594013 != nil:
    section.add "api-version", valid_594013
  var valid_594014 = query.getOrDefault("$top")
  valid_594014 = validateParameter(valid_594014, JInt, required = false, default = nil)
  if valid_594014 != nil:
    section.add "$top", valid_594014
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594015: Call_VaultsListBySubscription_594008; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The List operation gets information about the vaults associated with the subscription.
  ## 
  let valid = call_594015.validator(path, query, header, formData, body)
  let scheme = call_594015.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594015.url(scheme.get, call_594015.host, call_594015.base,
                         call_594015.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594015, url, valid)

proc call*(call_594016: Call_VaultsListBySubscription_594008; apiVersion: string;
          subscriptionId: string; Top: int = 0): Recallable =
  ## vaultsListBySubscription
  ## The List operation gets information about the vaults associated with the subscription.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   Top: int
  ##      : Maximum number of results to return.
  var path_594017 = newJObject()
  var query_594018 = newJObject()
  add(query_594018, "api-version", newJString(apiVersion))
  add(path_594017, "subscriptionId", newJString(subscriptionId))
  add(query_594018, "$top", newJInt(Top))
  result = call_594016.call(path_594017, query_594018, nil, nil, nil)

var vaultsListBySubscription* = Call_VaultsListBySubscription_594008(
    name: "vaultsListBySubscription", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.KeyVault/vaults",
    validator: validate_VaultsListBySubscription_594009, base: "",
    url: url_VaultsListBySubscription_594010, schemes: {Scheme.Https})
type
  Call_VaultsListByResourceGroup_594019 = ref object of OpenApiRestCall_593424
proc url_VaultsListByResourceGroup_594021(protocol: Scheme; host: string;
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

proc validate_VaultsListByResourceGroup_594020(path: JsonNode; query: JsonNode;
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
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   $top: JInt
  ##       : Maximum number of results to return.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594024 = query.getOrDefault("api-version")
  valid_594024 = validateParameter(valid_594024, JString, required = true,
                                 default = nil)
  if valid_594024 != nil:
    section.add "api-version", valid_594024
  var valid_594025 = query.getOrDefault("$top")
  valid_594025 = validateParameter(valid_594025, JInt, required = false, default = nil)
  if valid_594025 != nil:
    section.add "$top", valid_594025
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594026: Call_VaultsListByResourceGroup_594019; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The List operation gets information about the vaults associated with the subscription and within the specified resource group.
  ## 
  let valid = call_594026.validator(path, query, header, formData, body)
  let scheme = call_594026.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594026.url(scheme.get, call_594026.host, call_594026.base,
                         call_594026.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594026, url, valid)

proc call*(call_594027: Call_VaultsListByResourceGroup_594019;
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
  var path_594028 = newJObject()
  var query_594029 = newJObject()
  add(path_594028, "resourceGroupName", newJString(resourceGroupName))
  add(query_594029, "api-version", newJString(apiVersion))
  add(path_594028, "subscriptionId", newJString(subscriptionId))
  add(query_594029, "$top", newJInt(Top))
  result = call_594027.call(path_594028, query_594029, nil, nil, nil)

var vaultsListByResourceGroup* = Call_VaultsListByResourceGroup_594019(
    name: "vaultsListByResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.KeyVault/vaults",
    validator: validate_VaultsListByResourceGroup_594020, base: "",
    url: url_VaultsListByResourceGroup_594021, schemes: {Scheme.Https})
type
  Call_VaultsCreateOrUpdate_594041 = ref object of OpenApiRestCall_593424
proc url_VaultsCreateOrUpdate_594043(protocol: Scheme; host: string; base: string;
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

proc validate_VaultsCreateOrUpdate_594042(path: JsonNode; query: JsonNode;
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
  var valid_594044 = path.getOrDefault("resourceGroupName")
  valid_594044 = validateParameter(valid_594044, JString, required = true,
                                 default = nil)
  if valid_594044 != nil:
    section.add "resourceGroupName", valid_594044
  var valid_594045 = path.getOrDefault("subscriptionId")
  valid_594045 = validateParameter(valid_594045, JString, required = true,
                                 default = nil)
  if valid_594045 != nil:
    section.add "subscriptionId", valid_594045
  var valid_594046 = path.getOrDefault("vaultName")
  valid_594046 = validateParameter(valid_594046, JString, required = true,
                                 default = nil)
  if valid_594046 != nil:
    section.add "vaultName", valid_594046
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594047 = query.getOrDefault("api-version")
  valid_594047 = validateParameter(valid_594047, JString, required = true,
                                 default = nil)
  if valid_594047 != nil:
    section.add "api-version", valid_594047
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

proc call*(call_594049: Call_VaultsCreateOrUpdate_594041; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create or update a key vault in the specified subscription.
  ## 
  let valid = call_594049.validator(path, query, header, formData, body)
  let scheme = call_594049.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594049.url(scheme.get, call_594049.host, call_594049.base,
                         call_594049.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594049, url, valid)

proc call*(call_594050: Call_VaultsCreateOrUpdate_594041;
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
  var path_594051 = newJObject()
  var query_594052 = newJObject()
  var body_594053 = newJObject()
  add(path_594051, "resourceGroupName", newJString(resourceGroupName))
  add(query_594052, "api-version", newJString(apiVersion))
  add(path_594051, "subscriptionId", newJString(subscriptionId))
  add(path_594051, "vaultName", newJString(vaultName))
  if parameters != nil:
    body_594053 = parameters
  result = call_594050.call(path_594051, query_594052, nil, nil, body_594053)

var vaultsCreateOrUpdate* = Call_VaultsCreateOrUpdate_594041(
    name: "vaultsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.KeyVault/vaults/{vaultName}",
    validator: validate_VaultsCreateOrUpdate_594042, base: "",
    url: url_VaultsCreateOrUpdate_594043, schemes: {Scheme.Https})
type
  Call_VaultsGet_594030 = ref object of OpenApiRestCall_593424
proc url_VaultsGet_594032(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_VaultsGet_594031(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_594035 = path.getOrDefault("vaultName")
  valid_594035 = validateParameter(valid_594035, JString, required = true,
                                 default = nil)
  if valid_594035 != nil:
    section.add "vaultName", valid_594035
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
  if body != nil:
    result.add "body", body

proc call*(call_594037: Call_VaultsGet_594030; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the specified Azure key vault.
  ## 
  let valid = call_594037.validator(path, query, header, formData, body)
  let scheme = call_594037.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594037.url(scheme.get, call_594037.host, call_594037.base,
                         call_594037.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594037, url, valid)

proc call*(call_594038: Call_VaultsGet_594030; resourceGroupName: string;
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
  var path_594039 = newJObject()
  var query_594040 = newJObject()
  add(path_594039, "resourceGroupName", newJString(resourceGroupName))
  add(query_594040, "api-version", newJString(apiVersion))
  add(path_594039, "subscriptionId", newJString(subscriptionId))
  add(path_594039, "vaultName", newJString(vaultName))
  result = call_594038.call(path_594039, query_594040, nil, nil, nil)

var vaultsGet* = Call_VaultsGet_594030(name: "vaultsGet", meth: HttpMethod.HttpGet,
                                    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.KeyVault/vaults/{vaultName}",
                                    validator: validate_VaultsGet_594031,
                                    base: "", url: url_VaultsGet_594032,
                                    schemes: {Scheme.Https})
type
  Call_VaultsUpdate_594065 = ref object of OpenApiRestCall_593424
proc url_VaultsUpdate_594067(protocol: Scheme; host: string; base: string;
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

proc validate_VaultsUpdate_594066(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_594068 = path.getOrDefault("resourceGroupName")
  valid_594068 = validateParameter(valid_594068, JString, required = true,
                                 default = nil)
  if valid_594068 != nil:
    section.add "resourceGroupName", valid_594068
  var valid_594069 = path.getOrDefault("subscriptionId")
  valid_594069 = validateParameter(valid_594069, JString, required = true,
                                 default = nil)
  if valid_594069 != nil:
    section.add "subscriptionId", valid_594069
  var valid_594070 = path.getOrDefault("vaultName")
  valid_594070 = validateParameter(valid_594070, JString, required = true,
                                 default = nil)
  if valid_594070 != nil:
    section.add "vaultName", valid_594070
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594071 = query.getOrDefault("api-version")
  valid_594071 = validateParameter(valid_594071, JString, required = true,
                                 default = nil)
  if valid_594071 != nil:
    section.add "api-version", valid_594071
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

proc call*(call_594073: Call_VaultsUpdate_594065; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Update a key vault in the specified subscription.
  ## 
  let valid = call_594073.validator(path, query, header, formData, body)
  let scheme = call_594073.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594073.url(scheme.get, call_594073.host, call_594073.base,
                         call_594073.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594073, url, valid)

proc call*(call_594074: Call_VaultsUpdate_594065; resourceGroupName: string;
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
  var path_594075 = newJObject()
  var query_594076 = newJObject()
  var body_594077 = newJObject()
  add(path_594075, "resourceGroupName", newJString(resourceGroupName))
  add(query_594076, "api-version", newJString(apiVersion))
  add(path_594075, "subscriptionId", newJString(subscriptionId))
  add(path_594075, "vaultName", newJString(vaultName))
  if parameters != nil:
    body_594077 = parameters
  result = call_594074.call(path_594075, query_594076, nil, nil, body_594077)

var vaultsUpdate* = Call_VaultsUpdate_594065(name: "vaultsUpdate",
    meth: HttpMethod.HttpPatch, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.KeyVault/vaults/{vaultName}",
    validator: validate_VaultsUpdate_594066, base: "", url: url_VaultsUpdate_594067,
    schemes: {Scheme.Https})
type
  Call_VaultsDelete_594054 = ref object of OpenApiRestCall_593424
proc url_VaultsDelete_594056(protocol: Scheme; host: string; base: string;
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

proc validate_VaultsDelete_594055(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_594057 = path.getOrDefault("resourceGroupName")
  valid_594057 = validateParameter(valid_594057, JString, required = true,
                                 default = nil)
  if valid_594057 != nil:
    section.add "resourceGroupName", valid_594057
  var valid_594058 = path.getOrDefault("subscriptionId")
  valid_594058 = validateParameter(valid_594058, JString, required = true,
                                 default = nil)
  if valid_594058 != nil:
    section.add "subscriptionId", valid_594058
  var valid_594059 = path.getOrDefault("vaultName")
  valid_594059 = validateParameter(valid_594059, JString, required = true,
                                 default = nil)
  if valid_594059 != nil:
    section.add "vaultName", valid_594059
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594060 = query.getOrDefault("api-version")
  valid_594060 = validateParameter(valid_594060, JString, required = true,
                                 default = nil)
  if valid_594060 != nil:
    section.add "api-version", valid_594060
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594061: Call_VaultsDelete_594054; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the specified Azure key vault.
  ## 
  let valid = call_594061.validator(path, query, header, formData, body)
  let scheme = call_594061.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594061.url(scheme.get, call_594061.host, call_594061.base,
                         call_594061.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594061, url, valid)

proc call*(call_594062: Call_VaultsDelete_594054; resourceGroupName: string;
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
  var path_594063 = newJObject()
  var query_594064 = newJObject()
  add(path_594063, "resourceGroupName", newJString(resourceGroupName))
  add(query_594064, "api-version", newJString(apiVersion))
  add(path_594063, "subscriptionId", newJString(subscriptionId))
  add(path_594063, "vaultName", newJString(vaultName))
  result = call_594062.call(path_594063, query_594064, nil, nil, nil)

var vaultsDelete* = Call_VaultsDelete_594054(name: "vaultsDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.KeyVault/vaults/{vaultName}",
    validator: validate_VaultsDelete_594055, base: "", url: url_VaultsDelete_594056,
    schemes: {Scheme.Https})
type
  Call_VaultsUpdateAccessPolicy_594078 = ref object of OpenApiRestCall_593424
proc url_VaultsUpdateAccessPolicy_594080(protocol: Scheme; host: string;
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

proc validate_VaultsUpdateAccessPolicy_594079(path: JsonNode; query: JsonNode;
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
  var valid_594081 = path.getOrDefault("resourceGroupName")
  valid_594081 = validateParameter(valid_594081, JString, required = true,
                                 default = nil)
  if valid_594081 != nil:
    section.add "resourceGroupName", valid_594081
  var valid_594095 = path.getOrDefault("operationKind")
  valid_594095 = validateParameter(valid_594095, JString, required = true,
                                 default = newJString("add"))
  if valid_594095 != nil:
    section.add "operationKind", valid_594095
  var valid_594096 = path.getOrDefault("subscriptionId")
  valid_594096 = validateParameter(valid_594096, JString, required = true,
                                 default = nil)
  if valid_594096 != nil:
    section.add "subscriptionId", valid_594096
  var valid_594097 = path.getOrDefault("vaultName")
  valid_594097 = validateParameter(valid_594097, JString, required = true,
                                 default = nil)
  if valid_594097 != nil:
    section.add "vaultName", valid_594097
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594098 = query.getOrDefault("api-version")
  valid_594098 = validateParameter(valid_594098, JString, required = true,
                                 default = nil)
  if valid_594098 != nil:
    section.add "api-version", valid_594098
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

proc call*(call_594100: Call_VaultsUpdateAccessPolicy_594078; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Update access policies in a key vault in the specified subscription.
  ## 
  let valid = call_594100.validator(path, query, header, formData, body)
  let scheme = call_594100.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594100.url(scheme.get, call_594100.host, call_594100.base,
                         call_594100.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594100, url, valid)

proc call*(call_594101: Call_VaultsUpdateAccessPolicy_594078;
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
  var path_594102 = newJObject()
  var query_594103 = newJObject()
  var body_594104 = newJObject()
  add(path_594102, "resourceGroupName", newJString(resourceGroupName))
  add(path_594102, "operationKind", newJString(operationKind))
  add(query_594103, "api-version", newJString(apiVersion))
  add(path_594102, "subscriptionId", newJString(subscriptionId))
  add(path_594102, "vaultName", newJString(vaultName))
  if parameters != nil:
    body_594104 = parameters
  result = call_594101.call(path_594102, query_594103, nil, nil, body_594104)

var vaultsUpdateAccessPolicy* = Call_VaultsUpdateAccessPolicy_594078(
    name: "vaultsUpdateAccessPolicy", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.KeyVault/vaults/{vaultName}/accessPolicies/{operationKind}",
    validator: validate_VaultsUpdateAccessPolicy_594079, base: "",
    url: url_VaultsUpdateAccessPolicy_594080, schemes: {Scheme.Https})
type
  Call_VaultsList_594105 = ref object of OpenApiRestCall_593424
proc url_VaultsList_594107(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_VaultsList_594106(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_594108 = path.getOrDefault("subscriptionId")
  valid_594108 = validateParameter(valid_594108, JString, required = true,
                                 default = nil)
  if valid_594108 != nil:
    section.add "subscriptionId", valid_594108
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
  var valid_594109 = query.getOrDefault("api-version")
  valid_594109 = validateParameter(valid_594109, JString, required = true,
                                 default = newJString("2015-11-01"))
  if valid_594109 != nil:
    section.add "api-version", valid_594109
  var valid_594110 = query.getOrDefault("$top")
  valid_594110 = validateParameter(valid_594110, JInt, required = false, default = nil)
  if valid_594110 != nil:
    section.add "$top", valid_594110
  var valid_594111 = query.getOrDefault("$filter")
  valid_594111 = validateParameter(valid_594111, JString, required = true, default = newJString(
      "resourceType eq \'Microsoft.KeyVault/vaults\'"))
  if valid_594111 != nil:
    section.add "$filter", valid_594111
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594112: Call_VaultsList_594105; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The List operation gets information about the vaults associated with the subscription.
  ## 
  let valid = call_594112.validator(path, query, header, formData, body)
  let scheme = call_594112.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594112.url(scheme.get, call_594112.host, call_594112.base,
                         call_594112.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594112, url, valid)

proc call*(call_594113: Call_VaultsList_594105; subscriptionId: string;
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
  var path_594114 = newJObject()
  var query_594115 = newJObject()
  add(query_594115, "api-version", newJString(apiVersion))
  add(path_594114, "subscriptionId", newJString(subscriptionId))
  add(query_594115, "$top", newJInt(Top))
  add(query_594115, "$filter", newJString(Filter))
  result = call_594113.call(path_594114, query_594115, nil, nil, nil)

var vaultsList* = Call_VaultsList_594105(name: "vaultsList",
                                      meth: HttpMethod.HttpGet,
                                      host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resources",
                                      validator: validate_VaultsList_594106,
                                      base: "", url: url_VaultsList_594107,
                                      schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)

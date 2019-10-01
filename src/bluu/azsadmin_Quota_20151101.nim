
import
  json, options, hashes, uri, rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: SubscriptionsManagementClient
## version: 2015-11-01
## termsOfService: (not provided)
## license: (not provided)
## 
## The Admin Subscriptions Management Client.
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

  OpenApiRestCall_574442 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_574442](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_574442): Option[Scheme] {.used.} =
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
  macServiceName = "azsadmin-Quota"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_QuotasList_574664 = ref object of OpenApiRestCall_574442
proc url_QuotasList_574666(protocol: Scheme; host: string; base: string; route: string;
                          path: JsonNode; query: JsonNode): Uri =
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
        value: "/providers/Microsoft.Subscriptions.Admin/locations/"),
               (kind: VariableSegment, value: "location"),
               (kind: ConstantSegment, value: "/quotas")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_QuotasList_574665(path: JsonNode; query: JsonNode; header: JsonNode;
                               formData: JsonNode; body: JsonNode): JsonNode =
  ## Get the list of quotas at a location.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription.The subscription ID forms part of the URI for every service call.
  ##   location: JString (required)
  ##           : The AzureStack location.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_574826 = path.getOrDefault("subscriptionId")
  valid_574826 = validateParameter(valid_574826, JString, required = true,
                                 default = nil)
  if valid_574826 != nil:
    section.add "subscriptionId", valid_574826
  var valid_574827 = path.getOrDefault("location")
  valid_574827 = validateParameter(valid_574827, JString, required = true,
                                 default = nil)
  if valid_574827 != nil:
    section.add "location", valid_574827
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574841 = query.getOrDefault("api-version")
  valid_574841 = validateParameter(valid_574841, JString, required = true,
                                 default = newJString("2015-11-01"))
  if valid_574841 != nil:
    section.add "api-version", valid_574841
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574868: Call_QuotasList_574664; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get the list of quotas at a location.
  ## 
  let valid = call_574868.validator(path, query, header, formData, body)
  let scheme = call_574868.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574868.url(scheme.get, call_574868.host, call_574868.base,
                         call_574868.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574868, url, valid)

proc call*(call_574939: Call_QuotasList_574664; subscriptionId: string;
          location: string; apiVersion: string = "2015-11-01"): Recallable =
  ## quotasList
  ## Get the list of quotas at a location.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription.The subscription ID forms part of the URI for every service call.
  ##   location: string (required)
  ##           : The AzureStack location.
  var path_574940 = newJObject()
  var query_574942 = newJObject()
  add(query_574942, "api-version", newJString(apiVersion))
  add(path_574940, "subscriptionId", newJString(subscriptionId))
  add(path_574940, "location", newJString(location))
  result = call_574939.call(path_574940, query_574942, nil, nil, nil)

var quotasList* = Call_QuotasList_574664(name: "quotasList",
                                      meth: HttpMethod.HttpGet, host: "adminmanagement.local.azurestack.external", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Subscriptions.Admin/locations/{location}/quotas",
                                      validator: validate_QuotasList_574665,
                                      base: "", url: url_QuotasList_574666,
                                      schemes: {Scheme.Https})
type
  Call_QuotasGet_574981 = ref object of OpenApiRestCall_574442
proc url_QuotasGet_574983(protocol: Scheme; host: string; base: string; route: string;
                         path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "location" in path, "`location` is a required path parameter"
  assert "quota" in path, "`quota` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Subscriptions.Admin/locations/"),
               (kind: VariableSegment, value: "location"),
               (kind: ConstantSegment, value: "/quotas/"),
               (kind: VariableSegment, value: "quota")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_QuotasGet_574982(path: JsonNode; query: JsonNode; header: JsonNode;
                              formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a quota by name.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   quota: JString (required)
  ##        : Name of the quota.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription.The subscription ID forms part of the URI for every service call.
  ##   location: JString (required)
  ##           : The AzureStack location.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `quota` field"
  var valid_574993 = path.getOrDefault("quota")
  valid_574993 = validateParameter(valid_574993, JString, required = true,
                                 default = nil)
  if valid_574993 != nil:
    section.add "quota", valid_574993
  var valid_574994 = path.getOrDefault("subscriptionId")
  valid_574994 = validateParameter(valid_574994, JString, required = true,
                                 default = nil)
  if valid_574994 != nil:
    section.add "subscriptionId", valid_574994
  var valid_574995 = path.getOrDefault("location")
  valid_574995 = validateParameter(valid_574995, JString, required = true,
                                 default = nil)
  if valid_574995 != nil:
    section.add "location", valid_574995
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574996 = query.getOrDefault("api-version")
  valid_574996 = validateParameter(valid_574996, JString, required = true,
                                 default = newJString("2015-11-01"))
  if valid_574996 != nil:
    section.add "api-version", valid_574996
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574997: Call_QuotasGet_574981; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a quota by name.
  ## 
  let valid = call_574997.validator(path, query, header, formData, body)
  let scheme = call_574997.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574997.url(scheme.get, call_574997.host, call_574997.base,
                         call_574997.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574997, url, valid)

proc call*(call_574998: Call_QuotasGet_574981; quota: string; subscriptionId: string;
          location: string; apiVersion: string = "2015-11-01"): Recallable =
  ## quotasGet
  ## Gets a quota by name.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   quota: string (required)
  ##        : Name of the quota.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription.The subscription ID forms part of the URI for every service call.
  ##   location: string (required)
  ##           : The AzureStack location.
  var path_574999 = newJObject()
  var query_575000 = newJObject()
  add(query_575000, "api-version", newJString(apiVersion))
  add(path_574999, "quota", newJString(quota))
  add(path_574999, "subscriptionId", newJString(subscriptionId))
  add(path_574999, "location", newJString(location))
  result = call_574998.call(path_574999, query_575000, nil, nil, nil)

var quotasGet* = Call_QuotasGet_574981(name: "quotasGet", meth: HttpMethod.HttpGet, host: "adminmanagement.local.azurestack.external", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Subscriptions.Admin/locations/{location}/quotas/{quota}",
                                    validator: validate_QuotasGet_574982,
                                    base: "", url: url_QuotasGet_574983,
                                    schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)

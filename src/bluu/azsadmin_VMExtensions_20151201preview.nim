
import
  json, options, hashes, uri, rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: Compute Admin Client
## version: 2015-12-01-preview
## termsOfService: (not provided)
## license: (not provided)
## 
## 
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

  OpenApiRestCall_574441 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_574441](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_574441): Option[Scheme] {.used.} =
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
  macServiceName = "azsadmin-VMExtensions"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_VmextensionsList_574663 = ref object of OpenApiRestCall_574441
proc url_VmextensionsList_574665(protocol: Scheme; host: string; base: string;
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
        value: "/providers/Microsoft.Compute.Admin/locations/"),
               (kind: VariableSegment, value: "location"),
               (kind: ConstantSegment, value: "/artifactTypes/VMExtension")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VmextensionsList_574664(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## List of all Virtual Machine Extension Images for the current location are returned.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   location: JString (required)
  ##           : Location of the resource.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_574825 = path.getOrDefault("subscriptionId")
  valid_574825 = validateParameter(valid_574825, JString, required = true,
                                 default = nil)
  if valid_574825 != nil:
    section.add "subscriptionId", valid_574825
  var valid_574826 = path.getOrDefault("location")
  valid_574826 = validateParameter(valid_574826, JString, required = true,
                                 default = nil)
  if valid_574826 != nil:
    section.add "location", valid_574826
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574840 = query.getOrDefault("api-version")
  valid_574840 = validateParameter(valid_574840, JString, required = true,
                                 default = newJString("2015-12-01-preview"))
  if valid_574840 != nil:
    section.add "api-version", valid_574840
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574867: Call_VmextensionsList_574663; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List of all Virtual Machine Extension Images for the current location are returned.
  ## 
  let valid = call_574867.validator(path, query, header, formData, body)
  let scheme = call_574867.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574867.url(scheme.get, call_574867.host, call_574867.base,
                         call_574867.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574867, url, valid)

proc call*(call_574938: Call_VmextensionsList_574663; subscriptionId: string;
          location: string; apiVersion: string = "2015-12-01-preview"): Recallable =
  ## vmextensionsList
  ## List of all Virtual Machine Extension Images for the current location are returned.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   location: string (required)
  ##           : Location of the resource.
  var path_574939 = newJObject()
  var query_574941 = newJObject()
  add(query_574941, "api-version", newJString(apiVersion))
  add(path_574939, "subscriptionId", newJString(subscriptionId))
  add(path_574939, "location", newJString(location))
  result = call_574938.call(path_574939, query_574941, nil, nil, nil)

var vmextensionsList* = Call_VmextensionsList_574663(name: "vmextensionsList",
    meth: HttpMethod.HttpGet, host: "adminmanagement.local.azurestack.external", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Compute.Admin/locations/{location}/artifactTypes/VMExtension",
    validator: validate_VmextensionsList_574664, base: "",
    url: url_VmextensionsList_574665, schemes: {Scheme.Https})
type
  Call_VmextensionsCreate_575002 = ref object of OpenApiRestCall_574441
proc url_VmextensionsCreate_575004(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "location" in path, "`location` is a required path parameter"
  assert "publisher" in path, "`publisher` is a required path parameter"
  assert "type" in path, "`type` is a required path parameter"
  assert "version" in path, "`version` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Compute.Admin/locations/"),
               (kind: VariableSegment, value: "location"), (kind: ConstantSegment,
        value: "/artifactTypes/VMExtension/publishers/"),
               (kind: VariableSegment, value: "publisher"),
               (kind: ConstantSegment, value: "/types/"),
               (kind: VariableSegment, value: "type"),
               (kind: ConstantSegment, value: "/versions/"),
               (kind: VariableSegment, value: "version")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VmextensionsCreate_575003(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Create a Virtual Machine Extension Image with publisher, version.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   type: JString (required)
  ##       : Type of extension.
  ##   publisher: JString (required)
  ##            : Name of the publisher.
  ##   version: JString (required)
  ##          : The version of the resource.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   location: JString (required)
  ##           : Location of the resource.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `type` field"
  var valid_575005 = path.getOrDefault("type")
  valid_575005 = validateParameter(valid_575005, JString, required = true,
                                 default = nil)
  if valid_575005 != nil:
    section.add "type", valid_575005
  var valid_575006 = path.getOrDefault("publisher")
  valid_575006 = validateParameter(valid_575006, JString, required = true,
                                 default = nil)
  if valid_575006 != nil:
    section.add "publisher", valid_575006
  var valid_575007 = path.getOrDefault("version")
  valid_575007 = validateParameter(valid_575007, JString, required = true,
                                 default = nil)
  if valid_575007 != nil:
    section.add "version", valid_575007
  var valid_575008 = path.getOrDefault("subscriptionId")
  valid_575008 = validateParameter(valid_575008, JString, required = true,
                                 default = nil)
  if valid_575008 != nil:
    section.add "subscriptionId", valid_575008
  var valid_575009 = path.getOrDefault("location")
  valid_575009 = validateParameter(valid_575009, JString, required = true,
                                 default = nil)
  if valid_575009 != nil:
    section.add "location", valid_575009
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575010 = query.getOrDefault("api-version")
  valid_575010 = validateParameter(valid_575010, JString, required = true,
                                 default = newJString("2015-12-01-preview"))
  if valid_575010 != nil:
    section.add "api-version", valid_575010
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   extension: JObject (required)
  ##            : Virtual Machine Extension Image creation properties.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_575012: Call_VmextensionsCreate_575002; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create a Virtual Machine Extension Image with publisher, version.
  ## 
  let valid = call_575012.validator(path, query, header, formData, body)
  let scheme = call_575012.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575012.url(scheme.get, call_575012.host, call_575012.base,
                         call_575012.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575012, url, valid)

proc call*(call_575013: Call_VmextensionsCreate_575002; `type`: string;
          publisher: string; version: string; subscriptionId: string;
          extension: JsonNode; location: string;
          apiVersion: string = "2015-12-01-preview"): Recallable =
  ## vmextensionsCreate
  ## Create a Virtual Machine Extension Image with publisher, version.
  ##   type: string (required)
  ##       : Type of extension.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   publisher: string (required)
  ##            : Name of the publisher.
  ##   version: string (required)
  ##          : The version of the resource.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   extension: JObject (required)
  ##            : Virtual Machine Extension Image creation properties.
  ##   location: string (required)
  ##           : Location of the resource.
  var path_575014 = newJObject()
  var query_575015 = newJObject()
  var body_575016 = newJObject()
  add(path_575014, "type", newJString(`type`))
  add(query_575015, "api-version", newJString(apiVersion))
  add(path_575014, "publisher", newJString(publisher))
  add(path_575014, "version", newJString(version))
  add(path_575014, "subscriptionId", newJString(subscriptionId))
  if extension != nil:
    body_575016 = extension
  add(path_575014, "location", newJString(location))
  result = call_575013.call(path_575014, query_575015, nil, nil, body_575016)

var vmextensionsCreate* = Call_VmextensionsCreate_575002(
    name: "vmextensionsCreate", meth: HttpMethod.HttpPut,
    host: "adminmanagement.local.azurestack.external", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Compute.Admin/locations/{location}/artifactTypes/VMExtension/publishers/{publisher}/types/{type}/versions/{version}",
    validator: validate_VmextensionsCreate_575003, base: "",
    url: url_VmextensionsCreate_575004, schemes: {Scheme.Https})
type
  Call_VmextensionsGet_574980 = ref object of OpenApiRestCall_574441
proc url_VmextensionsGet_574982(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "location" in path, "`location` is a required path parameter"
  assert "publisher" in path, "`publisher` is a required path parameter"
  assert "type" in path, "`type` is a required path parameter"
  assert "version" in path, "`version` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Compute.Admin/locations/"),
               (kind: VariableSegment, value: "location"), (kind: ConstantSegment,
        value: "/artifactTypes/VMExtension/publishers/"),
               (kind: VariableSegment, value: "publisher"),
               (kind: ConstantSegment, value: "/types/"),
               (kind: VariableSegment, value: "type"),
               (kind: ConstantSegment, value: "/versions/"),
               (kind: VariableSegment, value: "version")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VmextensionsGet_574981(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Returns requested Virtual Machine Extension Image matching publisher, type, version.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   type: JString (required)
  ##       : Type of extension.
  ##   publisher: JString (required)
  ##            : Name of the publisher.
  ##   version: JString (required)
  ##          : The version of the resource.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   location: JString (required)
  ##           : Location of the resource.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `type` field"
  var valid_574992 = path.getOrDefault("type")
  valid_574992 = validateParameter(valid_574992, JString, required = true,
                                 default = nil)
  if valid_574992 != nil:
    section.add "type", valid_574992
  var valid_574993 = path.getOrDefault("publisher")
  valid_574993 = validateParameter(valid_574993, JString, required = true,
                                 default = nil)
  if valid_574993 != nil:
    section.add "publisher", valid_574993
  var valid_574994 = path.getOrDefault("version")
  valid_574994 = validateParameter(valid_574994, JString, required = true,
                                 default = nil)
  if valid_574994 != nil:
    section.add "version", valid_574994
  var valid_574995 = path.getOrDefault("subscriptionId")
  valid_574995 = validateParameter(valid_574995, JString, required = true,
                                 default = nil)
  if valid_574995 != nil:
    section.add "subscriptionId", valid_574995
  var valid_574996 = path.getOrDefault("location")
  valid_574996 = validateParameter(valid_574996, JString, required = true,
                                 default = nil)
  if valid_574996 != nil:
    section.add "location", valid_574996
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574997 = query.getOrDefault("api-version")
  valid_574997 = validateParameter(valid_574997, JString, required = true,
                                 default = newJString("2015-12-01-preview"))
  if valid_574997 != nil:
    section.add "api-version", valid_574997
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574998: Call_VmextensionsGet_574980; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns requested Virtual Machine Extension Image matching publisher, type, version.
  ## 
  let valid = call_574998.validator(path, query, header, formData, body)
  let scheme = call_574998.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574998.url(scheme.get, call_574998.host, call_574998.base,
                         call_574998.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574998, url, valid)

proc call*(call_574999: Call_VmextensionsGet_574980; `type`: string;
          publisher: string; version: string; subscriptionId: string;
          location: string; apiVersion: string = "2015-12-01-preview"): Recallable =
  ## vmextensionsGet
  ## Returns requested Virtual Machine Extension Image matching publisher, type, version.
  ##   type: string (required)
  ##       : Type of extension.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   publisher: string (required)
  ##            : Name of the publisher.
  ##   version: string (required)
  ##          : The version of the resource.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   location: string (required)
  ##           : Location of the resource.
  var path_575000 = newJObject()
  var query_575001 = newJObject()
  add(path_575000, "type", newJString(`type`))
  add(query_575001, "api-version", newJString(apiVersion))
  add(path_575000, "publisher", newJString(publisher))
  add(path_575000, "version", newJString(version))
  add(path_575000, "subscriptionId", newJString(subscriptionId))
  add(path_575000, "location", newJString(location))
  result = call_574999.call(path_575000, query_575001, nil, nil, nil)

var vmextensionsGet* = Call_VmextensionsGet_574980(name: "vmextensionsGet",
    meth: HttpMethod.HttpGet, host: "adminmanagement.local.azurestack.external", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Compute.Admin/locations/{location}/artifactTypes/VMExtension/publishers/{publisher}/types/{type}/versions/{version}",
    validator: validate_VmextensionsGet_574981, base: "", url: url_VmextensionsGet_574982,
    schemes: {Scheme.Https})
type
  Call_VmextensionsDelete_575017 = ref object of OpenApiRestCall_574441
proc url_VmextensionsDelete_575019(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "location" in path, "`location` is a required path parameter"
  assert "publisher" in path, "`publisher` is a required path parameter"
  assert "type" in path, "`type` is a required path parameter"
  assert "version" in path, "`version` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Compute.Admin/locations/"),
               (kind: VariableSegment, value: "location"), (kind: ConstantSegment,
        value: "/artifactTypes/VMExtension/publishers/"),
               (kind: VariableSegment, value: "publisher"),
               (kind: ConstantSegment, value: "/types/"),
               (kind: VariableSegment, value: "type"),
               (kind: ConstantSegment, value: "/versions/"),
               (kind: VariableSegment, value: "version")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VmextensionsDelete_575018(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Deletes specified Virtual Machine Extension Image.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   type: JString (required)
  ##       : Type of extension.
  ##   publisher: JString (required)
  ##            : Name of the publisher.
  ##   version: JString (required)
  ##          : The version of the resource.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   location: JString (required)
  ##           : Location of the resource.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `type` field"
  var valid_575020 = path.getOrDefault("type")
  valid_575020 = validateParameter(valid_575020, JString, required = true,
                                 default = nil)
  if valid_575020 != nil:
    section.add "type", valid_575020
  var valid_575021 = path.getOrDefault("publisher")
  valid_575021 = validateParameter(valid_575021, JString, required = true,
                                 default = nil)
  if valid_575021 != nil:
    section.add "publisher", valid_575021
  var valid_575022 = path.getOrDefault("version")
  valid_575022 = validateParameter(valid_575022, JString, required = true,
                                 default = nil)
  if valid_575022 != nil:
    section.add "version", valid_575022
  var valid_575023 = path.getOrDefault("subscriptionId")
  valid_575023 = validateParameter(valid_575023, JString, required = true,
                                 default = nil)
  if valid_575023 != nil:
    section.add "subscriptionId", valid_575023
  var valid_575024 = path.getOrDefault("location")
  valid_575024 = validateParameter(valid_575024, JString, required = true,
                                 default = nil)
  if valid_575024 != nil:
    section.add "location", valid_575024
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575025 = query.getOrDefault("api-version")
  valid_575025 = validateParameter(valid_575025, JString, required = true,
                                 default = newJString("2015-12-01-preview"))
  if valid_575025 != nil:
    section.add "api-version", valid_575025
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575026: Call_VmextensionsDelete_575017; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes specified Virtual Machine Extension Image.
  ## 
  let valid = call_575026.validator(path, query, header, formData, body)
  let scheme = call_575026.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575026.url(scheme.get, call_575026.host, call_575026.base,
                         call_575026.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575026, url, valid)

proc call*(call_575027: Call_VmextensionsDelete_575017; `type`: string;
          publisher: string; version: string; subscriptionId: string;
          location: string; apiVersion: string = "2015-12-01-preview"): Recallable =
  ## vmextensionsDelete
  ## Deletes specified Virtual Machine Extension Image.
  ##   type: string (required)
  ##       : Type of extension.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   publisher: string (required)
  ##            : Name of the publisher.
  ##   version: string (required)
  ##          : The version of the resource.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   location: string (required)
  ##           : Location of the resource.
  var path_575028 = newJObject()
  var query_575029 = newJObject()
  add(path_575028, "type", newJString(`type`))
  add(query_575029, "api-version", newJString(apiVersion))
  add(path_575028, "publisher", newJString(publisher))
  add(path_575028, "version", newJString(version))
  add(path_575028, "subscriptionId", newJString(subscriptionId))
  add(path_575028, "location", newJString(location))
  result = call_575027.call(path_575028, query_575029, nil, nil, nil)

var vmextensionsDelete* = Call_VmextensionsDelete_575017(
    name: "vmextensionsDelete", meth: HttpMethod.HttpDelete,
    host: "adminmanagement.local.azurestack.external", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Compute.Admin/locations/{location}/artifactTypes/VMExtension/publishers/{publisher}/types/{type}/versions/{version}",
    validator: validate_VmextensionsDelete_575018, base: "",
    url: url_VmextensionsDelete_575019, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)

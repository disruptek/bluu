
import
  json, options, hashes, uri, rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: StreamAnalyticsManagementClient
## version: 2016-03-01
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
  macServiceName = "streamanalytics-transformations"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_TransformationsCreateOrReplace_568194 = ref object of OpenApiRestCall_567657
proc url_TransformationsCreateOrReplace_568196(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "jobName" in path, "`jobName` is a required path parameter"
  assert "transformationName" in path,
        "`transformationName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourcegroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.StreamAnalytics/streamingjobs/"),
               (kind: VariableSegment, value: "jobName"),
               (kind: ConstantSegment, value: "/transformations/"),
               (kind: VariableSegment, value: "transformationName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TransformationsCreateOrReplace_568195(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a transformation or replaces an already existing transformation under an existing streaming job.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   subscriptionId: JString (required)
  ##                 : GUID which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   jobName: JString (required)
  ##          : The name of the streaming job.
  ##   transformationName: JString (required)
  ##                     : The name of the transformation.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568214 = path.getOrDefault("resourceGroupName")
  valid_568214 = validateParameter(valid_568214, JString, required = true,
                                 default = nil)
  if valid_568214 != nil:
    section.add "resourceGroupName", valid_568214
  var valid_568215 = path.getOrDefault("subscriptionId")
  valid_568215 = validateParameter(valid_568215, JString, required = true,
                                 default = nil)
  if valid_568215 != nil:
    section.add "subscriptionId", valid_568215
  var valid_568216 = path.getOrDefault("jobName")
  valid_568216 = validateParameter(valid_568216, JString, required = true,
                                 default = nil)
  if valid_568216 != nil:
    section.add "jobName", valid_568216
  var valid_568217 = path.getOrDefault("transformationName")
  valid_568217 = validateParameter(valid_568217, JString, required = true,
                                 default = nil)
  if valid_568217 != nil:
    section.add "transformationName", valid_568217
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568218 = query.getOrDefault("api-version")
  valid_568218 = validateParameter(valid_568218, JString, required = true,
                                 default = nil)
  if valid_568218 != nil:
    section.add "api-version", valid_568218
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString
  ##           : The ETag of the transformation. Omit this value to always overwrite the current transformation. Specify the last-seen ETag value to prevent accidentally overwriting concurrent changes.
  ##   If-None-Match: JString
  ##                : Set to '*' to allow a new transformation to be created, but to prevent updating an existing transformation. Other values will result in a 412 Pre-condition Failed response.
  section = newJObject()
  var valid_568219 = header.getOrDefault("If-Match")
  valid_568219 = validateParameter(valid_568219, JString, required = false,
                                 default = nil)
  if valid_568219 != nil:
    section.add "If-Match", valid_568219
  var valid_568220 = header.getOrDefault("If-None-Match")
  valid_568220 = validateParameter(valid_568220, JString, required = false,
                                 default = nil)
  if valid_568220 != nil:
    section.add "If-None-Match", valid_568220
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   transformation: JObject (required)
  ##                 : The definition of the transformation that will be used to create a new transformation or replace the existing one under the streaming job.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568222: Call_TransformationsCreateOrReplace_568194; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a transformation or replaces an already existing transformation under an existing streaming job.
  ## 
  let valid = call_568222.validator(path, query, header, formData, body)
  let scheme = call_568222.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568222.url(scheme.get, call_568222.host, call_568222.base,
                         call_568222.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568222, url, valid)

proc call*(call_568223: Call_TransformationsCreateOrReplace_568194;
          resourceGroupName: string; apiVersion: string; transformation: JsonNode;
          subscriptionId: string; jobName: string; transformationName: string): Recallable =
  ## transformationsCreateOrReplace
  ## Creates a transformation or replaces an already existing transformation under an existing streaming job.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   transformation: JObject (required)
  ##                 : The definition of the transformation that will be used to create a new transformation or replace the existing one under the streaming job.
  ##   subscriptionId: string (required)
  ##                 : GUID which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   jobName: string (required)
  ##          : The name of the streaming job.
  ##   transformationName: string (required)
  ##                     : The name of the transformation.
  var path_568224 = newJObject()
  var query_568225 = newJObject()
  var body_568226 = newJObject()
  add(path_568224, "resourceGroupName", newJString(resourceGroupName))
  add(query_568225, "api-version", newJString(apiVersion))
  if transformation != nil:
    body_568226 = transformation
  add(path_568224, "subscriptionId", newJString(subscriptionId))
  add(path_568224, "jobName", newJString(jobName))
  add(path_568224, "transformationName", newJString(transformationName))
  result = call_568223.call(path_568224, query_568225, nil, nil, body_568226)

var transformationsCreateOrReplace* = Call_TransformationsCreateOrReplace_568194(
    name: "transformationsCreateOrReplace", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/Microsoft.StreamAnalytics/streamingjobs/{jobName}/transformations/{transformationName}",
    validator: validate_TransformationsCreateOrReplace_568195, base: "",
    url: url_TransformationsCreateOrReplace_568196, schemes: {Scheme.Https})
type
  Call_TransformationsGet_567879 = ref object of OpenApiRestCall_567657
proc url_TransformationsGet_567881(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "jobName" in path, "`jobName` is a required path parameter"
  assert "transformationName" in path,
        "`transformationName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourcegroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.StreamAnalytics/streamingjobs/"),
               (kind: VariableSegment, value: "jobName"),
               (kind: ConstantSegment, value: "/transformations/"),
               (kind: VariableSegment, value: "transformationName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TransformationsGet_567880(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Gets details about the specified transformation.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   subscriptionId: JString (required)
  ##                 : GUID which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   jobName: JString (required)
  ##          : The name of the streaming job.
  ##   transformationName: JString (required)
  ##                     : The name of the transformation.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568054 = path.getOrDefault("resourceGroupName")
  valid_568054 = validateParameter(valid_568054, JString, required = true,
                                 default = nil)
  if valid_568054 != nil:
    section.add "resourceGroupName", valid_568054
  var valid_568055 = path.getOrDefault("subscriptionId")
  valid_568055 = validateParameter(valid_568055, JString, required = true,
                                 default = nil)
  if valid_568055 != nil:
    section.add "subscriptionId", valid_568055
  var valid_568056 = path.getOrDefault("jobName")
  valid_568056 = validateParameter(valid_568056, JString, required = true,
                                 default = nil)
  if valid_568056 != nil:
    section.add "jobName", valid_568056
  var valid_568057 = path.getOrDefault("transformationName")
  valid_568057 = validateParameter(valid_568057, JString, required = true,
                                 default = nil)
  if valid_568057 != nil:
    section.add "transformationName", valid_568057
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568058 = query.getOrDefault("api-version")
  valid_568058 = validateParameter(valid_568058, JString, required = true,
                                 default = nil)
  if valid_568058 != nil:
    section.add "api-version", valid_568058
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568081: Call_TransformationsGet_567879; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets details about the specified transformation.
  ## 
  let valid = call_568081.validator(path, query, header, formData, body)
  let scheme = call_568081.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568081.url(scheme.get, call_568081.host, call_568081.base,
                         call_568081.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568081, url, valid)

proc call*(call_568152: Call_TransformationsGet_567879; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; jobName: string;
          transformationName: string): Recallable =
  ## transformationsGet
  ## Gets details about the specified transformation.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : GUID which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   jobName: string (required)
  ##          : The name of the streaming job.
  ##   transformationName: string (required)
  ##                     : The name of the transformation.
  var path_568153 = newJObject()
  var query_568155 = newJObject()
  add(path_568153, "resourceGroupName", newJString(resourceGroupName))
  add(query_568155, "api-version", newJString(apiVersion))
  add(path_568153, "subscriptionId", newJString(subscriptionId))
  add(path_568153, "jobName", newJString(jobName))
  add(path_568153, "transformationName", newJString(transformationName))
  result = call_568152.call(path_568153, query_568155, nil, nil, nil)

var transformationsGet* = Call_TransformationsGet_567879(
    name: "transformationsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/Microsoft.StreamAnalytics/streamingjobs/{jobName}/transformations/{transformationName}",
    validator: validate_TransformationsGet_567880, base: "",
    url: url_TransformationsGet_567881, schemes: {Scheme.Https})
type
  Call_TransformationsUpdate_568227 = ref object of OpenApiRestCall_567657
proc url_TransformationsUpdate_568229(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "jobName" in path, "`jobName` is a required path parameter"
  assert "transformationName" in path,
        "`transformationName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourcegroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.StreamAnalytics/streamingjobs/"),
               (kind: VariableSegment, value: "jobName"),
               (kind: ConstantSegment, value: "/transformations/"),
               (kind: VariableSegment, value: "transformationName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TransformationsUpdate_568228(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates an existing transformation under an existing streaming job. This can be used to partially update (ie. update one or two properties) a transformation without affecting the rest the job or transformation definition.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   subscriptionId: JString (required)
  ##                 : GUID which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   jobName: JString (required)
  ##          : The name of the streaming job.
  ##   transformationName: JString (required)
  ##                     : The name of the transformation.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568230 = path.getOrDefault("resourceGroupName")
  valid_568230 = validateParameter(valid_568230, JString, required = true,
                                 default = nil)
  if valid_568230 != nil:
    section.add "resourceGroupName", valid_568230
  var valid_568231 = path.getOrDefault("subscriptionId")
  valid_568231 = validateParameter(valid_568231, JString, required = true,
                                 default = nil)
  if valid_568231 != nil:
    section.add "subscriptionId", valid_568231
  var valid_568232 = path.getOrDefault("jobName")
  valid_568232 = validateParameter(valid_568232, JString, required = true,
                                 default = nil)
  if valid_568232 != nil:
    section.add "jobName", valid_568232
  var valid_568233 = path.getOrDefault("transformationName")
  valid_568233 = validateParameter(valid_568233, JString, required = true,
                                 default = nil)
  if valid_568233 != nil:
    section.add "transformationName", valid_568233
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568234 = query.getOrDefault("api-version")
  valid_568234 = validateParameter(valid_568234, JString, required = true,
                                 default = nil)
  if valid_568234 != nil:
    section.add "api-version", valid_568234
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString
  ##           : The ETag of the transformation. Omit this value to always overwrite the current transformation. Specify the last-seen ETag value to prevent accidentally overwriting concurrent changes.
  section = newJObject()
  var valid_568235 = header.getOrDefault("If-Match")
  valid_568235 = validateParameter(valid_568235, JString, required = false,
                                 default = nil)
  if valid_568235 != nil:
    section.add "If-Match", valid_568235
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   transformation: JObject (required)
  ##                 : A Transformation object. The properties specified here will overwrite the corresponding properties in the existing transformation (ie. Those properties will be updated). Any properties that are set to null here will mean that the corresponding property in the existing transformation will remain the same and not change as a result of this PATCH operation.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568237: Call_TransformationsUpdate_568227; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates an existing transformation under an existing streaming job. This can be used to partially update (ie. update one or two properties) a transformation without affecting the rest the job or transformation definition.
  ## 
  let valid = call_568237.validator(path, query, header, formData, body)
  let scheme = call_568237.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568237.url(scheme.get, call_568237.host, call_568237.base,
                         call_568237.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568237, url, valid)

proc call*(call_568238: Call_TransformationsUpdate_568227;
          resourceGroupName: string; apiVersion: string; transformation: JsonNode;
          subscriptionId: string; jobName: string; transformationName: string): Recallable =
  ## transformationsUpdate
  ## Updates an existing transformation under an existing streaming job. This can be used to partially update (ie. update one or two properties) a transformation without affecting the rest the job or transformation definition.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   transformation: JObject (required)
  ##                 : A Transformation object. The properties specified here will overwrite the corresponding properties in the existing transformation (ie. Those properties will be updated). Any properties that are set to null here will mean that the corresponding property in the existing transformation will remain the same and not change as a result of this PATCH operation.
  ##   subscriptionId: string (required)
  ##                 : GUID which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   jobName: string (required)
  ##          : The name of the streaming job.
  ##   transformationName: string (required)
  ##                     : The name of the transformation.
  var path_568239 = newJObject()
  var query_568240 = newJObject()
  var body_568241 = newJObject()
  add(path_568239, "resourceGroupName", newJString(resourceGroupName))
  add(query_568240, "api-version", newJString(apiVersion))
  if transformation != nil:
    body_568241 = transformation
  add(path_568239, "subscriptionId", newJString(subscriptionId))
  add(path_568239, "jobName", newJString(jobName))
  add(path_568239, "transformationName", newJString(transformationName))
  result = call_568238.call(path_568239, query_568240, nil, nil, body_568241)

var transformationsUpdate* = Call_TransformationsUpdate_568227(
    name: "transformationsUpdate", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/Microsoft.StreamAnalytics/streamingjobs/{jobName}/transformations/{transformationName}",
    validator: validate_TransformationsUpdate_568228, base: "",
    url: url_TransformationsUpdate_568229, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
